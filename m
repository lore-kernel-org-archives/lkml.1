Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXAZTEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXAZTEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161197AbXAZTEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:04:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:50049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189AbXAZTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:04:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=fh8TmvrYFEuQvcD2MU2B8v7QX0gyQ5nTr49JrPxonFLPHgCh6sO/A2S4EaHmr/pMh7kazWJ7Mz0PRpLJXsDf30aKnUQIPU+fZal/APWtGUR0oFX2j4GPpuzaKCcjQji8yKGcZRp15ZwKzz2fKAHLowCrof37d4DILR5pYS0rESg=
Message-ID: <45BA50B7.1070205@googlemail.com>
Date: Fri, 26 Jan 2007 20:04:23 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Uwe Bugla <uwe.bugla@gmx.de>, B.Zolnierkiewicz@elka.pw.edu.pl,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Gerhard Dirschl <gd@spherenet.de>, Christoph Hellwig <hch@lst.de>,
       petero2@telia.com, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Venkat Yekkirala <vyekkirala@TrustedCS.com>,
       David Miller <davem@davemloft.net>, sds@tycho.nsa.gov,
       jmorris@namei.org, netdev@vger.kernel.org,
       Livio Soares <livio@eecg.toronto.edu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Cijoml Cijomlovic Cijomlov <cijoml@volny.cz>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ttb@tentacle.dhs.org,
       rml@novell.com, =?UTF-8?B?TWFsdGUgU2NocsO2ZGVy?= <MalteSch@gmx.de>,
       "Vladimir V. Saveliev" <vs@namesys.com>, reiserfs-dev@namesys.com,
       Sami Farin <7atbggg02@sneakemail.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com
Subject: Re: 2.6.20-rc6: known unfixed regressions (part 2)
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <20070126181132.GN17836@stusta.de>
In-Reply-To: <20070126181132.GN17836@stusta.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adrian Bunk napisał(a):
> This email lists some known regressions in 2.6.20-rc6 compared to 2.6.19
> that are not yet fixed in Linus' tree.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way possibly
> involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : SELinux compile error with CONFIG_XFRM=n
> References : http://lkml.org/lkml/2007/1/25/233
> Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
> Caused-By  : Venkat Yekkirala <vyekkirala@TrustedCS.com>
>              commit 334c85569b8adeaa820c0f2fab3c8f0a9dc8b92e
> Handled-By : Venkat Yekkirala <vyekkirala@TrustedCS.com>
>              David Miller <davem@davemloft.net>
> Status     : problem is being discussed
> 

Venkat Yekkirala has sent me a patch that fixed this build problem.

Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
