Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZFJSKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZFJSKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZFJSKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:10:05 -0400
Received: from main.gmane.org ([80.91.229.2]:44712 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbZFJSKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:10:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Subject: Re: [PATCH] hwmon: Add driver for VIA CPU core temperature
Date: Wed, 10 Jun 2009 17:40:31 +0000 (UTC)
Message-ID: <loom.20090610T172830-164@post.gmane.org>
References: <20090609083406.GE25316@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.20.248.126 (Opera/9.64 (Windows NT 5.1; U; en) Presto/2.1.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harald Welte <HaraldWelte <at> viatech.com> writes:

> 
> This is a driver for the on-die digital temperature sensor of
> VIA's recent CPU models.
> 
> Signed-off-by: Harald Welte <HaraldWelte <at> viatech.com>
> 

Harald,

I tested it on 2.6.28.3 kernel on VIA VB7002 motherboard and it does not work 
correctly.

Output form sensors:

via-cputemp-isa-0000
Adapter: ISA adapter
Core 0:       +0.0 C

On the other hand 
cat '/sys/class/hwmon/hwmon2/device/driver/via-cputemp.0/temp1_input' outputs 
numbers between 25-27. 

Tomaz Mertelj


