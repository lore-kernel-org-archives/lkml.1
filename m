Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbYEGGBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbYEGGBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYEGGB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:01:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22666 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYEGGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:01:26 -0400
Date: Wed, 7 May 2008 08:01:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: djwong@us.ibm.com, mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [resend] [PATCH v2] ibmaem: New driver for  power/energy meters
 in IBM System X hardware
Message-ID: <20080507080105.5484c58a@hyperion.delvare>
In-Reply-To: <20080506173607.71eb7257.akpm@linux-foundation.org>
References: <20080503045558.GJ16078@tree.beaverton.ibm.com>
	<20080505135621.66809b0e.akpm@linux-foundation.org>
	<20080505230440.GE16404@tree.beaverton.ibm.com>
	<20080506140433.0fa6e68e.akpm@linux-foundation.org>
	<20080506223812.GF16404@tree.beaverton.ibm.com>
	<20080506173607.71eb7257.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 17:36:07 -0700, Andrew Morton wrote:
> A checkpatch version which you might not have says
> 
> WARNING: consider using strict_strtol in preference to simple_strtol
> #1015: FILE: drivers/hwmon/ibmaem.c:918:
> +       int temp = simple_strtol(buf, NULL, 10); \
> 
> total: 0 errors, 1 warnings, 1221 lines checked
> 
> because the code as you have it will accept input of the form "12foo". 
> strict_strtol() will error on that.

As a side note, I really wonder why this new function wasn't named just
strtol(), especially if the general idea is to get rid of the "simple"
variant after some time.

-- 
Jean Delvare
