Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbXE0LkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbXE0LkE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXE0Ljy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:39:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:56889 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXE0Ljy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:39:54 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86: fix section mismatch warnings in mtrr
Date: Sun, 27 May 2007 13:39:35 +0200
User-Agent: KMail/1.9.6
Cc: Indan Zupancic <indan@nul.nu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       Bernhard Walle <bwalle@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200705191443.27161.arvidjaar@mail.ru> <200705261802.08573.ak@suse.de> <20070527090542.GA18399@uranus.ravnborg.org>
In-Reply-To: <20070527090542.GA18399@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705271339.36045.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The whole purpose with __init and friends are the possibility to drop
> the .init.text (+ .init.data) section when the kernel is up and running.

I know what they do, you don't need to repeatedly reexplain them.

My point was just that in all the __init/__initdata warnings I recently fixed
personally there wasn't a single one that wasn't a false positive and frankly I don't
see any sign of them really showing real bugs. Basically effort:gain doesn't
seem to be well balanced here.

-Andi
