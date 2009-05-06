Return-Path: <linux-kernel-owner+w=401wt.eu-S1759278AbZEFLVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278AbZEFLVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZEFLVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:21:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022AbZEFLVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:21:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A00EF23.4050302@snapgear.com>
References: <4A00EF23.4050302@snapgear.com> <49FF96A7.5040401@snapgear.com> <3662.1241530861@redhat.com>
To: Greg Ungerer <gerg@snapgear.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: BUG: failure at mm/nommu.c:518/add_nommu_region()
Date: Wed, 06 May 2009 12:21:26 +0100
Message-ID: <22890.1241608886@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer <gerg@snapgear.com> wrote:

> ___ REGION ERROR ___
> 18b790-191db0
> fs=romfs file=init
> BUG: failure at mm/nommu.c:532/add_nommu_region()!
> Kernel panic - not syncing: BUG!
> 
> 
> > Also if you can check to see whether the region is within the ROMFS image.
> 
> Yes, it is. As per the uclinux/mtd trace output (at top of trace
> above). The start physical address of the ROMFS is 0x168fc0, and
> it will end at 0x23ffc0.

Okay...  XIP regions must avoid the check.

David
