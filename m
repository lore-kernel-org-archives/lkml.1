Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbZFMOCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbZFMOCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbZFMOCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:02:11 -0400
Received: from fifo99.com ([67.223.236.141]:60513 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbZFMOCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:02:10 -0400
Subject: Re: [PATCH 08/14] Pramfs: Makefile and Kconfig
From: Daniel Walker <dwalker@fifo99.com>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A33A802.8040507@gmail.com>
References: <4A33A802.8040507@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 07:02:12 -0700
Message-Id: <1244901732.5982.221.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 15:22 +0200, Marco wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Makefile and Kconfig.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 

You should move this patch to 11 of 14, as I think that is the point
when the filesystem can actually be enabled and function. If this series
is only applied up to this patch you can get build failures if you
enabled PRAMFS, XIP, or any of the other features. Also breaking out the
individual features menuconfig options like XIP, and write protect, etc,
into their respective patches would be nice.

Daniel

