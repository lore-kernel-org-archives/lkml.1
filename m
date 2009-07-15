Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbZGOKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbZGOKeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZGOKd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:33:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41334 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZGOKd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:33:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A5CFFD8.7020106@t-online.de>
References: <4A5CFFD8.7020106@t-online.de> <1247591665-12000-1-git-send-email-vapier@gentoo.org> <20090714161416.GA19147@cmpxchg.org> <6206.1247592126@redhat.com>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: dhowells@redhat.com, Mike Frysinger <vapier@gentoo.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v2] NOMMU: add support for Memory Protection Units (MPU)
Date: Wed, 15 Jul 2009 11:31:40 +0100
Message-ID: <12331.1247653900@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Schmidt <bernds_cb1@t-online.de> wrote:

> No page table, just three bitmaps (r/w/x), with one bit per page, per mm.

That sounds a bit inefficient as you have to make three accesses per page.  I
suppose it depends on how your MPU works.

David
