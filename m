Return-Path: <linux-kernel-owner+w=401wt.eu-S933508AbXGUV2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933508AbXGUV2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbXGUV2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:28:23 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3051 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760669AbXGUV2V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:28:21 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: from where comes "__moddi3"?
Date: Sat, 21 Jul 2007 14:27:09 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEAPFIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <71a0d6ff0707211300p57f31ec1md4a4848e5580c682@mail.gmail.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 21 Jul 2007 14:27:48 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 21 Jul 2007 14:27:50 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On 7/21/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> > v & 0x0F  <=>  v % 16
> Indeed. (Why would anyone want to mod/div by 15 anyway?). My bad.

Actually, it's the compiler's bad. That's a pretty fundamental equivalence that the compiler should recognize for native integral types.

DS


