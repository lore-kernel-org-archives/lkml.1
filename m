Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbXFZLno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbXFZLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 07:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXFZLng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 07:43:36 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:62869 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbXFZLng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 07:43:36 -0400
Date: Tue, 26 Jun 2007 07:43:27 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86_84: move iommu declaration from proto to iommu.h
Message-ID: <20070626114327.GD4320@rhun.ibm.com>
References: <200706221219.16243.yinghai.lu@sun.com> <200706221934.59966.yinghai.lu@sun.com> <200706251234.04548.yinghai.lu@sun.com> <200706251449.27260.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706251449.27260.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 02:49:26PM -0700, Yinghai Lu wrote:

> [PATCH 2/2] x86_84: move iommu declaration from proto to iommu.h

Sorry for the hassle, but this patch should come first and then your
current first patch becomes much simpler and does not touch proto.h
needlessly.

Also, I still think an iommu_ops is a better approach. I'll put
something together when I add the Calgary shutdown bits next week
after OLS.

Cheers,
Muli
