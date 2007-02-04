Return-Path: <linux-kernel-owner+w=401wt.eu-S1752372AbXBDRuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbXBDRuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 12:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXBDRuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 12:50:10 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1510 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbXBDRuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 12:50:08 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: mm: how to check for kernel pages
Date: Sun, 4 Feb 2007 09:49:55 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKMENMBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070204165407.GD10477@curandero.marconia.cz>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 09:50:14 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 09:50:15 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, so what everything should be checked?
>
> - PageReserved
> - PageSlab
> - PageLocked
> - PageBuddy
> - PageCompound
> - PageNosave
> - PageNosaveFree
> - kernel page
> - userspace active DMA as you've mentioned. But I don't know how to test
>   it

Perhaps I'm missing something obvious, but shouldn't this just be the same
check to see if the page can be swapped out or discarded? Surely any page
that can be swapped out or discarded can be migrated. There might
theoretically be some pages that can't be swapped out or discarded that
could be migrated, but why not just ignore those cases?

DS


