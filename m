Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbXFLSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbXFLSlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXFLSlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:41:37 -0400
Received: from server001.webpack.hosteurope.de ([80.237.130.9]:43664 "EHLO
	server001.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756335AbXFLSlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:41:36 -0400
From: Andi Drebes <lists-receive@programmierforen.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [KJ] [PATCH] drivers/acpi: sizeof/sizeof array size calculations replaced with ARRAY_SIZE
Date: Tue, 12 Jun 2007 20:41:05 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Len Brown <lenb@kernel.org>, kernel-janitors@lists.osdl.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200705261239.27485.lists-receive@programmierforen.de> <20070610105712.GA4695@ucw.cz> <200706101544.35463.bjorn.helgaas@hp.com>
In-Reply-To: <200706101544.35463.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706122041.06252.lists-receive@programmierforen.de>
X-bounce-key: webpack.hosteurope.de;lists-receive@programmierforen.de;1181673696;e080f81a;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First off: sorry for my late answer.

> I agree the ACPI CA is a nuisance.  But in this case, we're making
> a mountain out of a molehill.  I suspect that if somebody spent the
> 15 minutes to make the ARRAY_SIZE patch work in both the Linux ACPI CA
> and the generic Intel one and license it appropriately, Len would
> happily apply the patch.
I hope I got everything right. Here's what I understood so far:

The ACPI Subsystem in the kernel is derived from intel sources. I searched
the web for information about that and finally found

http://www.intel.com/technology/iapc/acpi/downloads.htm

Is that the right one? So what I would have to do in order to
"make the ARRAY_SIZE patch work in both the Linux ACPI CA
and the generic Intel one" is to modify those sources aswell,
send a patch to Intel and another one back to the
lkml.

Is that right? Or am I totally wrong?

	Cheers,
		Andi
