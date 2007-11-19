Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbXKSV43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbXKSV43 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbXKSV4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:56:10 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1783 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXKSV4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:56:08 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Time-based RFC 4122 UUID generator
Date: Mon, 19 Nov 2007 13:56:04 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <fhqbkn$ttt$1@ger.gmane.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 19 Nov 2007 13:57:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 19 Nov 2007 13:57:08 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > I use libuuid and I assume libuuid uses some uuid generator support
> > from the kernel.
>
> No, it does not. It's pure userspace and may produce double UUIDs.
>
> > libuuid comes from a package that Ted's maintain IIRC.
> >
> > I (my company) use uuid to uniquely identify objects in a distributed
> > database.
> > [Proprietary closed source stuff].
>
> Same here.
>
> Helge

Any UUID generator that can produce duplicate UUIDs with probability
significantly less than purely random UUIDs is so badly broken that it
should not ever be used. Anyone who finds such a UUID generator should
immediately either fix it or throw it on the junk heap. Anyone who knowingly
uses such a UUID generator should be publically shamed.

Rather than (or at the very least, in addition to) adding a new UUID
generator, let's fix the one(s) we have.

DS


