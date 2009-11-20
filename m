Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZKTL4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZKTL4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZKTL4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:56:49 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33362 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751594AbZKTL4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:56:48 -0500
X-Sasl-enc: Smxh0Ya3+rk2+uJGvHjDqbWM2hlPbPEM38GHt3eqih6k 1258718214
Message-ID: <4B068402.7020606@ladisch.de>
Date: Fri, 20 Nov 2009 12:56:50 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] k10temp: temperature sensor for AMD Family 10h/11h
 CPUs
References: <4AF91F70.10106@ladisch.de>	<4B06501B.8080509@ladisch.de>	<87ws1l5wcl.fsf@depni.sinp.msu.ru>	<4B0673D7.5010006@ladisch.de> <20091120123016.19d98ab4@hyperion.delvare>
In-Reply-To: <20091120123016.19d98ab4@hyperion.delvare>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 20 Nov 2009 11:47:51 +0100, Clemens Ladisch wrote:
> > v2: Erratum 319 now results in a warning, not an error, because it cannot
> >     be reliably detected; Serge Belyshev reports that his CPU sensor works.
> 
> Nack. Unreliable sensors -> the default must be to NOT bind to these
> CPUs. ... Otherwise your driver will _never_ make it into the
> kernel tree.

Then how did the k8temp driver make it into the kernel tree?  :-)

> Feel free to provide a way to force the bind to happen (and still
> print a big fat warning that this is a very bad idea), but do NOT make
> it the default. 

Okay, I'll add a force parameter.
I'd guess k8temp should get the same?


Best regards,
Clemens
