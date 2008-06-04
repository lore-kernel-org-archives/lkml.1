Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbYFDOCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbYFDOCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYFDOCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:02:03 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:47004 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYFDOCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:02:01 -0400
Message-ID: <4846A04F.1030909@grupopie.com>
Date: Wed, 04 Jun 2008 15:01:51 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Keith Owens <kaos@ocs.com.au>
Subject: Re: [RFC PATCH] drop support for KALLSYMS_EXTRA_PASS
References: <20080603210732.GA6247@uranus.ravnborg.org>
In-Reply-To: <20080603210732.GA6247@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> We have not seen any reports on inconsistent kallsysms data recently
> as in the last one or two years. At least I do not recall these
> and google had no hits in my searching.
> 
> So I suggest removing this as to simplify the final linking.
> When doing "make allyesconfig" build this extra linking
> takes considerably time (and I usually forgoet to turn it off).

I don't remember any recent (read: in the last few years) problems 
either, so I guess this is ok.

> In addition this patch removes the debug target: debug_kallsyms

This might be useful if changes in some binutils version creates new 
problems for kallsyms, but it doesn't seem like a lot of work to just 
send a reporter a patch to add this back if needed. Since there haven't 
been any reports in a few years, I have no problems with this.

Acked-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"'thinking outside the box' works better if I know what's inside the box."
