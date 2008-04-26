Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbYDZOxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbYDZOxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYDZOxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:53:01 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:43095 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYDZOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:53:00 -0400
Date: Sat, 26 Apr 2008 16:51:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: mainline boot failures I: qemu II
Message-ID: <20080426145157.GA19781@basil.nowhere.org>
References: <20080426140210.GA13365@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426140210.GA13365@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Apr 2008 14:45:07.0108 (UTC) FILETIME=[1EAF5640:01C8A7AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ACPI: APIC 1FFF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
> No NUMA configuration found
> Faking a node at 0000000000000000-000000001fff0000
> Bootmem setup node 0 0000000000000000-000000001fff0000
>   NODE_DATA [000000000000b000 - 0000000000011fff]
>   bootmap [0000000000012000 -  0000000000015fff] pages 4
> early res: 0 [0-fff] BIOS data page
> PANIC: early exception 06 rip 10:ffffffff8083b23e error 0 cr2 0

Never mind. That one was caused by a mistake here (local patch) that
I didn't notice. When I fix that I just get the set_entity scheduler
oops in qemu the other systems are seeing.

-Andi
