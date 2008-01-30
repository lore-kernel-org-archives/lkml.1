Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbYA3UuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbYA3UuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:50:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYA3UuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:50:10 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:4799 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYA3UuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:50:08 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Pavel Roskin" <proski@gnu.org>
Cc: <linux-kernel@vger.kernel.org>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Giridhar Pemmasani" <pgiri@yahoo.com>
Subject: RE: ndiswrapper and GPL-only symbols redux
Date: Wed, 30 Jan 2008 12:50:02 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKAEDNJPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20080130050424.GA22444@dallas.jonmasters.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 30 Jan 2008 12:51:22 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 30 Jan 2008 12:51:22 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I wouldn't quite say that. I wasn't going to comment, but...personally,
> I actually disagree with the assertions that ndiswrapper isn't causing
> proprietary code to link against GPL functions in the kernel (how is
> an NDIS implementation any different than a shim layer provided to
> load a graphics driver?), but I wasn't trying to make that point.

By that logic, the kernel should always be tainted since it could
potentially always be linked to non-GPL code.

The ndiswrapper code is just like the kernel. It is GPL, but it could be
linked to non-free code. Any reason why ndiswrapper should be tainted would
equally well argue that any kernel with module-loading capability should be
tainted. Somebody might load a non-free module.

DS


