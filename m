Return-Path: <linux-kernel-owner+w=401wt.eu-S1759655AbXG2Cw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655AbXG2Cw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbXG2CwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:52:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:1716 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbXG2CwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Xv0P0hgl9Uyhpy336gpSSNxk9oIADDT2t1EzOhv/A7Y+b0aZxJSEH3ooMvO000ix0aoRiXPaUzyYKj2h7UK/TP8/rVLWF3wrST+h2PfvHZ+y1tCMkiqqlO4SAi7EIojPyEMDp2sHnSQacCd/lK4VrqZhZuJkwftrx0UariF1tfY=
Message-ID: <46ABFFE4.3060703@googlemail.com>
Date: Sun, 29 Jul 2007 04:48:04 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Danny ter Haar <dth@dth.net>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References: <20070727193832.GA20289@dth.net> <200707290142.53689.bzolnier@gmail.com> <20070729012324.GA29723@dth.net>
In-Reply-To: <20070729012324.GA29723@dth.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Danny ter Haar wrote:
> Quoting Bartlomiej Zolnierkiewicz (bzolnier@gmail.com):
>> Please retry with the latest -git kernel and if the problem is still
>> there install git, get kernel tree and run git-bisect.
> 
> I ran over "make menuconfig" and did a few changes.
> 
> http://www.dth.net/kernel/config-2.6.23-rc1-git5
> 

Maybe try to : 

disable BSG ( maybe some leftover bug )
boot acpi=off ( that got merged kind late )

> 
> Danny


Gabriel
