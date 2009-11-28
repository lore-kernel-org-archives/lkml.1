Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZK1Htu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZK1Htu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 02:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZK1Htt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 02:49:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbZK1Htt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 02:49:49 -0500
Date: Fri, 27 Nov 2009 23:48:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
Message-Id: <20091127234836.d33c9841.akpm@linux-foundation.org>
In-Reply-To: <20091127164333.75e20c8f@hyperion.delvare>
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
	<20091127164333.75e20c8f@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 16:43:33 +0100 Jean Delvare <khali@linux-fr.org> wrote:

> Hi Clemens,
> 
> On Tue, 24 Nov 2009 09:43:39 +0100, Clemens Ladisch wrote:
> > This adds a driver for the internal temperature sensor of AMD Family 10h
> > and 11h CPUs.
> > 
> > Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> > ---
> > v3: added 'force' parameter for CPUs with buggy sensor; more documentation
> > v4: added max/crit values, other changes suggested by Jean Delvare
> > 
> >  Documentation/hwmon/k10temp |   60 +++++++++
> >  drivers/hwmon/Kconfig       |   12 +
> >  drivers/hwmon/Makefile      |    1
> >  drivers/hwmon/k10temp.c     |  197 ++++++++++++++++++++++++++++++++
> >  4 files changed, 270 insertions(+)
> 
> Looks alright to me.
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
> If this is OK with you, I can add this patch to my hwmon tree and
> schedule it for merge in kernel 2.6.33.

Sounds good, thanks.
