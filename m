Return-Path: <linux-kernel-owner+w=401wt.eu-S1764134AbYDYUJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764134AbYDYUJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760544AbYDYUJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:09:09 -0400
Received: from pearlgates.net ([82.92.180.13]:53797 "EHLO mail.pearlgates.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760480AbYDYUJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:09:08 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2008 16:09:07 EDT
Date: Fri, 25 Apr 2008 21:59:05 +0200
From: Jos van der Ende <seraph@xs4all.nl>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SPARC64] INO problem Re: [Bug 10273] New: Sun GEM (PCI) -
 network device doesn't work
Message-Id: <20080425215905.0d21f5ca.seraph@xs4all.nl>
In-Reply-To: <20080425.002636.250010462.davem@davemloft.net>
References: <20080317143624.da313311.akpm@linux-foundation.org>
	<20080402182655.GA2739@ami.dom.local>
	<20080425.002636.250010462.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please give this patch a try (this is against 2.6.23, which is the
> version you reported the bug against, let me know if another version
> is more convenient).

I applied the patch against 2.6.24-gentoo-r4, the current kernel on this machine. It worked fine, with only an offset of 12 lines. Nothing unusual during compile either.

The first results are hopeful: I am no longer able to trigger this bug by loading sym53c8xx before sungem, nor by having them both loaded by udev. Nothing odd in dmesg and the machine is completely functional.


I don't have much time for testing today, but if desired I will gladly do some more testing tomorrow or Sunday.


-- 
Jos van der Ende <seraph@xs4all.nl>
