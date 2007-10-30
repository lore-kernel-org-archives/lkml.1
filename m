Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXJ3W2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXJ3W2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXJ3W15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:27:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbXJ3W15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:27:57 -0400
Date: Tue, 30 Oct 2007 15:28:16 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Norbert Preining <preining@logic.at>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-Id: <20071030152816.f2e8dd7c.zaitcev@redhat.com>
In-Reply-To: <20071030212213.GA13410@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
	<20071030211729.6a80a93a.Kristoffer.ericson@gmail.com>
	<20071030204720.GI8479@gamma.logic.tuwien.ac.at>
	<47279EF7.3040406@redhat.com>
	<20071030212213.GA13410@gamma.logic.tuwien.ac.at>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 22:22:13 +0100, Norbert Preining <preining@logic.at> wrote:

> I tried the attached patch which I found on the usb list, but it didn't
> work, the cdrom was still always found, and it was
> connected/disconnected permanently.

The difference with huaweiAktBbo.c seems that kernel uses a nonzero length.
Can you try zero length with the kernel? It's the second argument to the last.

-- Pete
