Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXEZQCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXEZQCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbXEZQCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:02:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:49407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXEZQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:02:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Date: Sat, 26 May 2007 18:02:08 +0200
User-Agent: KMail/1.9.6
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       "Bernhard Walle" <bwalle@suse.de>
References: <200705191443.27161.arvidjaar@mail.ru> <20070521151139.GA1929@uranus.ravnborg.org> <4498.81.207.0.53.1180181244.squirrel@secure.samage.net>
In-Reply-To: <4498.81.207.0.53.1180181244.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261802.08573.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 14:07:24 Indan Zupancic wrote:

> 
> Did the patches reach 2.6.22-rc3 yet?

No.

> 
> If they did, then the following warnings might need fixing:

There is already one patch queued for it. But actually in my experience I cannot
remember a single real bug showed by these warnings. All were false positives
and there are always more of them.

Maybe it would be best to disable these warnings again; not much good 
seems to come from them.

-Andi

> WARNING: arch/i386/kernel/built-in.o(.text+0x84bc): Section mismatch: reference to
>.init.text:amd_init_mtrr (between 'mtrr_bp_init' and 'mtrr_attrib_to_str')
>WARNING: arch/i386/kernel/built-in.o(.text+0x84c1): Section mismatch: reference to
>.init.text:cyrix_init_mtrr (between 'mtrr_bp_init' and 'mtrr_attrib_to_str')
