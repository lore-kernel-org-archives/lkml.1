Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZCLOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZCLOrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756564AbZCLOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:47:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbZCLOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:47:10 -0400
Message-ID: <49B92064.7000101@zytor.com>
Date: Thu, 12 Mar 2009 07:47:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ttyS* names missing in /proc/interrupts?
References: <Pine.SOC.4.64.0903121418240.11504@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0903121418240.11504@math.ut.ee>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
> Just noticed in 2.6.29-rc7+git: lines corresponding to 8250 ttyS* 
> serial ports have no device name in /proc interrupts:

They only show up while the ports are open and the interrupt enabled.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

