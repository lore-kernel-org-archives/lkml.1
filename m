Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbXL1Xe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbXL1Xe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXL1Xes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:34:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:52822 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXL1Xer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:34:47 -0500
Date: Fri, 28 Dec 2007 15:32:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q? "Oliver_Pinter_(Pint=E9r_Oliv=E9r)" ?= 
	<oliver.pntr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.23(?)=<] X used greatest stack depth: N bytes left
Message-Id: <20071228153258.bef76bb2.randy.dunlap@oracle.com>
In-Reply-To: <6101e8c40712281311p446f64e1xb28f8fc273545041@mail.gmail.com>
References: <6101e8c40712281311p446f64e1xb28f8fc273545041@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Dec 2007 22:11:25 +0100 Oliver Pinter (Pintér Olivér) wrote:

> in newer kernel I recently see this warnings:
> 
> X used greatest stack depth: N bytes left
> 
> X E { program name }
> N E { x byte }
> 
> ----------------8<--------------
> ...
> khelper used greatest stack depth: 7496 bytes left
> khelper used greatest stack depth: 7184 bytes left
> ...
> khelper used greatest stack depth: 6328 bytes left
> stty used greatest stack depth: 6180 bytes left
> mount used greatest stack depth: 6156 bytes left
> mknod used greatest stack depth: 5932 bytes left
> ...
> wpa_supplicant used greatest stack depth: 5740 bytes left
> ...
> dhclient3 used greatest stack depth: 5500 bytes left
> ----------------8<--------------
> 
> it is the "results" of the CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACK_USAGE=y options or it's other problem or feature?

CONFIG_DEBUG_STACK_USAGE, in kernel/exit.c:

---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
