Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbXHGSYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbXHGSYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbXHGSXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:23:42 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1039 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXHGSXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:23:40 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: RE: MODULE_LICENSE usage
Date: Tue, 7 Aug 2007 11:22:49 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEGKFPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
x-mimeole: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 07 Aug 2007 11:23:35 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 07 Aug 2007 11:23:37 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> My company has been given documentation and the library source under
> the terms of an NDA with the chipset manufacturer.  We are permitted
> to compile the library and distribute the resultant binary blob, but
> not release the source to the library.

> The binary blob is linked into the driver we have written.  We don't
> distribute this compiled module, customers are given the driver source
> and the library blob, which they compile themselves.

Make absolutely 100% sure that your driver source code is not a derivative
work of any existing kernel code. If it is, you may be violating the
copyright of that code just by distributing the source to your driver. If
your driver takes sufficient protectable elements both from the kernel and
the library, it cannot be distributed in source code form.

I would definitely consult a good lawyer to make sure you aren't breaking
any of the rules.

As for the MODULE_LICENSE tag, if it's supposed to indicate the library the
module is under after it's compiled, it's definitely not GPL or GPL with
additional rights. Since you can't get the source code to the entire module
and can't distribute the binary, it's under a proprietary license.

DS


