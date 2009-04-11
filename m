Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZDKTRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZDKTRa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758796AbZDKTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:17:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757590AbZDKTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:17:18 -0400
Date: Sat, 11 Apr 2009 12:14:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q? "Tiago_Sim=F5es_Batista" ?= 
	<tiagosbatista@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: High latency on /sys/class/thermal
Message-Id: <20090411121416.91fe3c88.akpm@linux-foundation.org>
In-Reply-To: <20090411155612.5808570c@ua.pt>
References: <20090411155612.5808570c@ua.pt>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-acpi)

On Sat, 11 Apr 2009 15:56:12 +0100 "Tiago Sim__es Batista" <tiagosbatista@gmail.com> wrote:

> Hi all
> 
> Yesterday, I recompiled my kernel (git + tuxonice)
> v2.6.30-rc1-1002-gac91f91, there were a couple of issues, the main one
> is ilustrated bellow.
> 
> I am not familiar with the kernel code, but if you give me some
> pointers, I will be glad to investigate this further
> 
> $time cat /sys/class/thermal/thermal_zone0/temp 
> 34000
> 
> real	0m6.613s
> user	0m0.000s
> sys	0m0.001s
> 

Is this a regression?  Was 2.6.29 OK?

Thanks.
