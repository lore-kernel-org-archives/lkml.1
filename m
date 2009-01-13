Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZAMMUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZAMMUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZAMMUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:20:45 -0500
Received: from netgear.net.ru ([195.178.208.66]:36028 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbZAMMUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:20:44 -0500
Date: Tue, 13 Jan 2009 15:20:42 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113122042.GA25011@ioremap.net>
References: <496C73DE.3030600@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496C73DE.3030600@wpkg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:58:38AM +0100, Tomasz Chmielewski (mangoo@wpkg.org) wrote:
> config ANDROID_LOW_MEMORY_KILLER
>         bool "Android Low Memory Killer"
>         default N
>         ---help---
>           Register processes to be killed when memory is low
> 
> available in Staging drivers / Android?

It looks very similar to vanilla process selection to be killed, but it
gets into account only rss size before the oom parameters.

-- 
	Evgeniy Polyakov
