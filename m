Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbXCUXb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbXCUXb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXCUXb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:31:56 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2812 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXCUXb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:31:56 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Date: Wed, 21 Mar 2007 16:31:52 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEBICHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <4040.81.207.0.53.1174478934.squirrel@secure.samage.net>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 16:32:02 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 16:32:04 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> If you can't read protect your kernel, you can't write protect it
> either.

This is so misleading as to basically be false.

It is true that any security scheme that can prevent people from taking
money out of my account can also prevent people from putting money in.
However, the set of people I allow to put money in my account might include
people I don't want to be able to take money out.

As a more concrete counter-example, consider a signed kernel module that I
wish to publically distribute. I can't stop anyone from reading it. I can
certainly keep people from changing the copy running on my machine.

Your point is not even valid about keys residing in RAM. There are perfectly
sensible scenarios in which the same key needs to be in several different
places, some very secure, some not so. Using a symettric key means that the
securest use can be compromised by a break of the least-secure use. Consider
data that is signed by the kernel and verified by a user-space program.

DS


