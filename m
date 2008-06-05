Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbYFEWLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbYFEWLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 18:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYFEWL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 18:11:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54532 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbYFEWL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 18:11:27 -0400
Message-ID: <4848648D.8010501@garzik.org>
Date: Thu, 05 Jun 2008 18:11:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>
In-Reply-To: <20080605.foo@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my "ideal firmware world":

* do NOT remove ability to compile firmware into the kernel (or into a 
module)

* firmware should be field-replaceable, even if one was compiled in

* the preferred form of firmware is one or more binary blobs, stored in 
a regular [filesystem|git] binary file.

* the preferred form is NOT ascii C source, or any other format other 
than the native format that the hardware wants.  Remember, the vendor 
only provided an ASCII-ized firmware because our system required it that 
way, not because that's the preferred form.

* in-tree firmwares should be stored in one or more binary files in the 
tree, not in C source code or .ihex files.

* when firmware is stored as binary blob, it is easier for
	(1) vendor to replace,
	(2) developer/user to compare/verify using sha1,
	(3) does not require a C compiler or binutils to unpack


Thus, if you are going to be touching the in-tree firmwares at all, it 
doesn't make sense to convert from C source to any format other than 
native binary.

	Jeff





