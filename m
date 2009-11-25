Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbZKYTrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbZKYTrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759427AbZKYTrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:47:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759367AbZKYTri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:47:38 -0500
Date: Wed, 25 Nov 2009 11:45:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org, x86@kernel.org
Subject: Re: [PATCH v4] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
Message-Id: <20091125114544.df69cc98.akpm@linux-foundation.org>
In-Reply-To: <4B0B9CBB.2050107@ladisch.de>
References: <4AF91F70.10106@ladisch.de>
	<4B06501B.8080509@ladisch.de>
	<87ws1l5wcl.fsf@depni.sinp.msu.ru>
	<4B0673D7.5010006@ladisch.de>
	<20091120123016.19d98ab4@hyperion.delvare>
	<4B068402.7020606@ladisch.de>
	<20091120131855.7f8f8722@hyperion.delvare>
	<4B0A3DB6.9090703@ladisch.de>
	<20091123145154.5b2b5735@hyperion.delvare>
	<4B0AAA55.3040702@ladisch.de>
	<20091123200527.1114cbc2@hyperion.delvare>
	<4B0B9CBB.2050107@ladisch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 09:43:39 +0100
Clemens Ladisch <clemens@ladisch.de> wrote:

> This adds a driver for the internal temperature sensor of AMD Family 10h
> and 11h CPUs.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
> v3: added 'force' parameter for CPUs with buggy sensor; more documentation
> v4: added max/crit values, other changes suggested by Jean Delvare

Pierre's happy now?

>
> ...
>
> +#define REG_HARDWARE_THERMAL_CONTROL	0x64
> +#define  HTC_ENABLE			0x00000001
> +
> +#define REG_REPORTED_TEMPERATURE	0xa4
> +
> +#define REG_NORTHBRIDGE_CAPABILITIES	0xe8
> +#define  NB_CAP_HTC			0x00000400

These definitions relate to register addresses within the AMD CPUs,
yes?  I wonder if these should be placed in some header file in
arch/x86/include/asm/ where other such things are described.

