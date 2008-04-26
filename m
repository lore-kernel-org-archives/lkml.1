Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbYDZJSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbYDZJSH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYDZJRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:17:54 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1139 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYDZJRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:17:53 -0400
Date: Sat, 26 Apr 2008 11:17:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: alek.du@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i2c: Add Intel SCH I2C SMBus support
Message-ID: <20080426111733.135e3f0a@hyperion.delvare>
In-Reply-To: <20080425231001.97cabebc.akpm@linux-foundation.org>
References: <20080422100420.3ee5f150@dxy.sh.intel.com>
	<20080423143212.36dba2ea@hyperion.delvare>
	<20080425231001.97cabebc.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 23:10:01 -0700, Andrew Morton wrote:
> I worry about the inclusion of apm_bios.h.  The driver is configured to be
> available on all architectures but apm_bios.h is surely x86-specific (and
> maybe mips).
> 
> But afaict the inclusion is not needed?

Indeed not. It was copied from i2c-piix4, which includes it since the
beginning of times for no good reason. I just posted a patch fixing
i2c-piix4:
http://lists.lm-sensors.org/pipermail/i2c/2008-April/003414.html

-- 
Jean Delvare
