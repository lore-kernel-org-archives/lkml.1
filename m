Return-Path: <linux-kernel-owner+w=401wt.eu-S934351AbXC2Vrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbXC2Vrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934354AbXC2Vrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:47:40 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2046 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934351AbXC2Vrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:47:39 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Why is NCQ enabled by default by libata? (2.6.20)
Date: Thu, 29 Mar 2007 14:47:20 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEAICKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <460BF73C.5070707@cfl.rr.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 29 Mar 2007 14:47:32 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 29 Mar 2007 14:47:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But when writing, what is the difference between queuing multiple tagged 
> writes, and sending down multiple untagged cached writes that complete 
> immediately and actually hit the disk later?  Either way the host keeps 
> sending writes to the disk until it's buffers are full, and the disk is 
> constantly trying to commit those buffers to the media in the most 
> optimal order.

Which sounds faster to you:

1) "Do A, B, C, and D."
   "Okay, I've finished A, B, C, and B."
or

2) "Do A."
   "Okay." 
   "Do B."
   "Okay."
   "Do C."
   "Okay."
   "Do D."
   "Okay."

The first looks a bit more efficient to me.

	DS


