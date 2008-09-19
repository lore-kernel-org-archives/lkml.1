Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYISSjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYISSjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 14:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYISSjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 14:39:42 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:33974 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYISSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 14:39:42 -0400
Date: Fri, 19 Sep 2008 11:39:36 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: Print cpuid along with the timestamp with
	CONFIG_PRINTK_TIME
Message-ID: <20080919183936.GA28992@localdomain>
References: <20080918193720.GA21915@localdomain> <20080918125123.1a76978f.akpm@linux-foundation.org> <20080919003509.GB21915@localdomain> <20080919171516.GB5540@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919171516.GB5540@joi>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 07:15:21PM +0200, Marcin Slusarz wrote:
>
>Do we really need this information on UP kernels?

I thought about it, and left it as the way it is to have a consistent format
between UP and SMP.  With most of the modern cpus being multicore, or headed
that way, and since the entire timestamp prefix  can be controlled by a boot
option, is it worth having different formats for UP and SMP?  Most distros
ship SMP kernels anyways.
