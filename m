Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZLCQPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZLCQPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 11:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZLCQPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 11:15:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZLCQPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 11:15:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8bd0f97a0912021441m5976be3dw29eef46ba4e76bf9@mail.gmail.com>
References: <8bd0f97a0912021441m5976be3dw29eef46ba4e76bf9@mail.gmail.com> <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com> <15859.1259763330@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: dhowells@redhat.com, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
Date: Thu, 03 Dec 2009 16:14:49 +0000
Message-ID: <14703.1259856889@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier.adi@gmail.com> wrote:

> actually, there's one typo here.  you want:
> flush_icache_range(region->vm_start, region->vm_end);

Good catch, thanks.

David
