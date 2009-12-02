Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbZLBXwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbZLBXwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbZLBXwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:52:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbZLBXwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:52:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0912021340l47b861a6l8444f8246581375@mail.gmail.com>
References: <8bd0f97a0912021340l47b861a6l8444f8246581375@mail.gmail.com> <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com> <15859.1259763330@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
Date: Wed, 02 Dec 2009 23:51:51 +0000
Message-ID: <31779.1259797911@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> it works, but i think we want to put the vm_icache_flushed in
> linux/mm_types.h behind NOMMU so we dont bloat the MMU guys ?

No.  The vm_region struct just isn't used in MMU-mode.

David
