Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXJBPt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXJBPt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJBPtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:49:50 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2446 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbXJBPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:49:49 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: RE: get amount of "entropy" in /dev/random ?
Date: Tue, 2 Oct 2007 08:49:36 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEEHHDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <f36b08ee0710020825x559a1046n6b7a2070d5591320@mail.gmail.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 02 Oct 2007 08:50:27 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 02 Oct 2007 08:50:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> From the userlevel, can I get an estimate of  "amount of entropy"
> in /dev/random, that is, the estimate of number of bytes
> readable until it blocks ? Of course multiple processes
> can read bytes and this would not be exact ... but still .. as an upper
> boundary estimate ?
>
> Thanks
> Yakov

Yes. Look in drivers/char/random.c at the random_ioctl handler. You will see
RNDGETENTCNT.

DS


