Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbYD1MGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbYD1MGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765251AbYD1MGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:06:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765164AbYD1MG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:06:29 -0400
Date: Mon, 28 Apr 2008 05:05:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org
Subject: Re: i2c or eeprom enumeration problem
Message-Id: <20080428050515.fcc05689.akpm@linux-foundation.org>
In-Reply-To: <4815509A.9040802@redhat.com>
References: <4815509A.9040802@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 21:20:42 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On a NUMA system the eeprom interface in /sys
> 
>   /sys/bus/i2c/drivers/eeprom/*
> 
> do not list all the DRAM eeproms.  Only the DRAM from one node is
> listed.  I have a 4 socket system with all 16 banks filled and see only
> 4 entries.
> 
> My suspicion (without looking at any code) is that the list of i2c
> devices with eeproms is collected once and this happens only on one CPU.
>  I sees not to be dynamic since when I read the files with taskset
> restricting execution on certain sockets and cores the result doesn't
> change.
> 
> Is this known or expected (I hope not the latter)?  Where should I look
> at?  I assume that's in the i2c code?
> 

Let's cc the i2c list.
