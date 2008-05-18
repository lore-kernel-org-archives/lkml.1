Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYERRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYERRH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYERRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:07:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:18164 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYERRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Sk4Dod0BdULES1kqM93nAmzTMWJmcT59uPgkcPWWumhB6xAAOgZsox199HUd+aJ5W49858jYdL5SpzbcX1nWj8WNdGOob6K2S7JD50Y/KsiY0Z2BqGrHqzh/tuwXAMmEOV2wyZuXDe011K6NR6En8F4XVRg+TDjFCdGVZ4wCd1Y=
Message-ID: <2f11576a0805181007n14592bd0r1cf8aec915894ed5@mail.gmail.com>
Date: Mon, 19 May 2008 02:07:11 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.26-rc2-mm1 - kernel bug while bootup at __alloc_pages_internal () on x86_64
Cc: LKML <linux-kernel@vger.kernel.org>, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, linux-mm@kvack.org, mingo@elte.hu,
       kosaki.motohiro@jp.fujitsu.com, kosaki.motohiro@gmail.com
In-Reply-To: <20080518080013.GA17458@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	 <482ACBFE.9010606@linux.vnet.ibm.com>
	 <20080514103601.32d20889.akpm@linux-foundation.org>
	 <482B2DB0.9030102@linux.vnet.ibm.com>
	 <20080514124455.cf7c3097.akpm@linux-foundation.org>
	 <20080518080013.GA17458@linux.vnet.ibm.com>
X-Google-Sender-Auth: 0261b4a030daa5fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After bisecting, the acpi-acpi_numa_init-build-fix.patch patch seems
> to be causing the kernel panic during the bootup. Reverting the patch helps
> in booting up the machine without the panic.
>
> commit 5dc90c0b2d4bd0127624bab67cec159b2c6c4daf
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu May 1 09:51:47 2008 +0000
>
>    acpi-acpi_numa_init-build-fix

this patch break Fujitsu ia64 numa box too.
after revert, my test environment works well.

Thanks.
