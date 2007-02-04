Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbXBDA4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbXBDA4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbXBDA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:56:09 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2164 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXBDA4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:56:08 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Philippe Troin" <phil@fifi.org>
Cc: "Denis Vlasenko" <vda.linux@googlemail.com>,
       <linux-kernel@vger.kernel.org>
Subject: RE: O_NONBLOCK setting "leak" outside of a process??
Date: Sat, 3 Feb 2007 16:55:29 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEJJBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <E0CFA8EB-F706-49E8-A1D1-7BAF19C8D271@e18.physik.tu-muenchen.de>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 16:55:44 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 03 Feb 2007 16:55:45 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> That's a bug, right? I couldn't find anything to that effect in IEEE
> Std. 1003.1, 2004 Edition...
>
> Ciao,
>                      Roland

It's not a bug, there's no rational alternative. What would two indepedent
file descriptors for the same end of a TCP connection be? What happens when
you call 'dup' on a file descriptor? The behavior is both the only logical
behavior and consistent with other cases where a file descriptor is
split/duplicated.

DS


