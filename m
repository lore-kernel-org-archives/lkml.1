Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZKTLaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZKTLaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZKTLaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:30:13 -0500
Received: from poutre.nerim.net ([62.4.16.124]:56778 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZKTLaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:30:12 -0500
Date: Fri, 20 Nov 2009 12:30:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH v2] k10temp: temperature sensor for AMD
 Family  10h/11h CPUs
Message-ID: <20091120123016.19d98ab4@hyperion.delvare>
In-Reply-To: <4B0673D7.5010006@ladisch.de>
References: <4AF91F70.10106@ladisch.de>
	<4B06501B.8080509@ladisch.de>
	<87ws1l5wcl.fsf@depni.sinp.msu.ru>
	<4B0673D7.5010006@ladisch.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 11:47:51 +0100, Clemens Ladisch wrote:
> This adds a driver for the internal temperature sensor of AMD Family 10h
> and 11h CPUs.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
> v2: Erratum 319 now results in a warning, not an error, because it cannot
>     be reliably detected; Serge Belyshev reports that his CPU sensor works.

Nack. Unreliable sensors -> the default must be to NOT bind to these
CPUs. Feel free to provide a way to force the bind to happen (and still
print a big fat warning that this is a very bad idea), but do NOT make
it the default. Otherwise your driver will _never_ make it into the
kernel tree.

As a side note I'd be curious to see what Serge calls "working
sensors". We had several reports in the past of people who claimed that
their sensors were working. After looking at their numbers, I had doubt
this really was the case.

-- 
Jean Delvare
