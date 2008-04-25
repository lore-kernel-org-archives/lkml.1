Return-Path: <linux-kernel-owner+w=401wt.eu-S1764957AbYDYUgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957AbYDYUgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764559AbYDYUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:36:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755751AbYDYUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:35:58 -0400
Date: Fri, 25 Apr 2008 13:35:58 -0700 (PDT)
Message-Id: <20080425.133558.15713665.davem@davemloft.net>
To: seraph@xs4all.nl
Cc: jarkao2@gmail.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SPARC64] INO problem Re: [Bug 10273] New: Sun GEM (PCI) -
 network device doesn't work
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080425215905.0d21f5ca.seraph@xs4all.nl>
References: <20080402182655.GA2739@ami.dom.local>
	<20080425.002636.250010462.davem@davemloft.net>
	<20080425215905.0d21f5ca.seraph@xs4all.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jos van der Ende <seraph@xs4all.nl>
Date: Fri, 25 Apr 2008 21:59:05 +0200

> > Please give this patch a try (this is against 2.6.23, which is the
> > version you reported the bug against, let me know if another version
> > is more convenient).
> 
> I applied the patch against 2.6.24-gentoo-r4, the current kernel on this machine. It worked fine, with only an offset of 12 lines. Nothing unusual during compile either.
> 
> The first results are hopeful: I am no longer able to trigger this bug by loading sym53c8xx before sungem, nor by having them both loaded by udev. Nothing odd in dmesg and the machine is completely functional.
> 
> 
> I don't have much time for testing today, but if desired I will gladly do some more testing tomorrow or Sunday.

Thanks for testing the change, I'll do some of my own testing and push
the bug fix upstream.

Thanks again!
