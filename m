Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbYENEvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbYENEvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYENEve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:51:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56888 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbYENEvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:51:33 -0400
Date: Tue, 13 May 2008 21:51:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] Example use of WARN()
Message-ID: <20080513215125.53424262@infradead.org>
In-Reply-To: <20080513213606.1a295609.akpm@linux-foundation.org>
References: <20080506232017.247001e0@infradead.org>
	<20080506232113.7f066c26@infradead.org>
	<20080506232156.159ed493@infradead.org>
	<20080513213606.1a295609.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 21:36:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 6 May 2008 23:21:56 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: Example use of WARN()
> > 
> > now that WARN() exists, we can fold some of the printk's into it
> 
> Wanna take a look at mips allnoconfig, please?
> 
> lib/kobject.c: In function `kobject_add_internal':
> lib/kobject.c:218: error: implicit declaration of function `WARN'
> 
> # CONFIG_BUG is not set


> 


I'll take a look tomorrow at work when I have access to more beefy
build stuff
