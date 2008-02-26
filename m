Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYBZBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYBZBax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 20:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYBZBan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 20:30:43 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3172 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbYBZBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 20:30:42 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: RE: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Date: Mon, 25 Feb 2008 17:30:40 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <47C3078E.3000008@redhat.com>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 25 Feb 2008 17:32:06 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 25 Feb 2008 17:32:07 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The reason I added GPL is not because of some idea that this is all
> "chummy" with the kernel. But because I derived the mcount code from
> glibc's version of mcount. Now you may argue that glibc is under LGPL
> and a non-GPL export is fine. But I've been advised that if I ever take
> code from someone else, to always export it with GPL.
>
> -- Steve

I don't know who told you that or why, but it's obvious nonsense, as this
issue shows. Exports should be marked GPL if and only if they cannot be used
except in a derivative work. If it is possible to use them without taking
sufficient protectable expression, they should not be marked GPL.

This was what everyone agreed to when GPL exports were created.

DS


