Return-Path: <linux-kernel-owner+w=401wt.eu-S1751432AbZIJOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbZIJOsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 10:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZIJOsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 10:48:20 -0400
Received: from fifo99.com ([67.223.236.141]:34977 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZIJOsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 10:48:19 -0400
Subject: Re: [PATCH] fix lock imbalances in /drivers/media/video/cafe_ccic.c
From: Daniel Walker <dwalker@fifo99.com>
To: iceberg <strakh@ispras.ru>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200909101837.34472.strakh@ispras.ru>
References: <200909101837.34472.strakh@ispras.ru>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 07:48:44 -0700
Message-Id: <1252594124.30578.181.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 18:37 +0000, iceberg wrote:
> In ./drivers/media/video/cafe_ccic.c, in function cafe_pci_probe: 
> Mutex must be unlocked before exit
> 	1. On paths starting with mutex lock in line 1912, then continuing in lines: 
> 1929, 1936 (goto unreg) and 1940 (goto iounmap) . 
> 	2. On path starting in line 1971 mutex lock, and then continuing in line 1978 
> (goto out_smbus) mutex.
> 
> Fix lock imbalances in function cafe_pci_probe.
> Found by Linux Driver Verification project.

Could you run this through checkpatch and fix any issues you find? It
looks like you need to use tabs for indentation in a couple places.

Daniel

