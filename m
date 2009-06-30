Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZF3VNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZF3VNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZF3VNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:13:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51276 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZF3VNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:13:00 -0400
Date: Tue, 30 Jun 2009 22:12:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: "Leo (Hao) Chen" <leochen@broadcom.com>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 3/6][ARM] new ARM SoC support: BCMRing
Message-ID: <20090630211249.GA10001@n2100.arm.linux.org.uk>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C3@SJEXCHCCR02.corp.ad.broadcom.com> <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C5@SJEXCHCCR02.corp.ad.broadcom.com> <20090627053317.GG8587@game.jcrosoft.org> <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE1A06@SJEXCHCCR02.corp.ad.broadcom.com> <5d5443650906292230k27e70863l49566462328f0a43@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d5443650906292230k27e70863l49566462328f0a43@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:00:41AM +0530, Trilok Soni wrote:
> Hi Leo,
> 
> > I'll fix the errors found by the checkpatch.pl script.  Is it okay to pass the checkpatch.pl with some warnings?
> >
> 
> I don't think so, but if you find any false positives you can report to ML.

The answer is actually yes.  For instance, if you have a prink where
the string you're printing goes over the 80 column limit, you have two
choices:

1. wrap the string.  This is considered bad practice since it means
   that you can't grep the kernel source for the exact message.

2. leave the string as is and ignore the checkpatch warning.

(2) is considered better practice than (1).
