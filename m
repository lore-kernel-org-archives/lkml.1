Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXFILkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXFILkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 07:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbXFILkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 07:40:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43780 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbXFILkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 07:40:19 -0400
Subject: Re: [4/4] 2.6.22-rc3: known regressions
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, video4linux@list.redhat.com,
       Hans Verkuil <hverkuil@xs4all.nl>, Robert Fitzsimons <robfitz@273k.net>,
       Len Brown <lenb@kernel.org>, Thierry Volpiatto <tvolpiatt@neuf.fr>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
In-Reply-To: <465C222C.3020203@googlemail.com>
References: <465C188F.9000900@googlemail.com>
	 <465C222C.3020203@googlemail.com>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 08:38:18 -0300
Message-Id: <1181389098.3877.96.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> Subject    : V4L ABI breakage
> References : http://lkml.org/lkml/2007/5/14/42
> Submitter  : Robert Fitzsimons <robfitz@273k.net>
> Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
>              Mauro Carvalho Chehab <mchehab@infradead.org>
>              commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
> Workaround : http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=15ac2d293b08b6975c6ca1a80eb839d4cb0dddbf
> Status     : problem is being debugged

I've just sent today a pull request to Linus with the proper fixes for
this issue. Some changes were done at the ABI to avoid the breakage,
while keeping the capability to control TV Out on ivtv driver. The
changes are being tested since Jun, 2.

The related changesets are those:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=987e00ba5cf667beed2b88bd1d01150334cdb6dc
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=1f137600cacf9a2908529c7d544de82672226a98

-- 
Cheers,
Mauro

