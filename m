Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbYC0VSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbYC0VSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 17:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbYC0VSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 17:18:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757563AbYC0VSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 17:18:33 -0400
Date: Thu, 27 Mar 2008 14:17:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Hitoshi Mitake <h.mitake@gmail.com>
Subject: Re: [PATCH 2/3] EDAC Fix module initialization on several modules
Message-Id: <20080327141749.585fb35a.akpm@linux-foundation.org>
In-Reply-To: <47e17dda.Gkad5p5g8/aS4wLG%dougthompson@xmission.com>
References: <47e17dda.Gkad5p5g8/aS4wLG%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 14:55:54 -0600
dougthompson@xmission.com wrote:

> From: Hitoshi Mitake <h.mitake@gmail.com>
> 
> I implmented opstate_init() as a inline function in linux/edac.h .
> 
> added calling opstate_init() to:
> 	i82443bxgx_edac.c
> 	i82860_edac.c
> 	i82875p_edac.c and 
> 	i82975x_edac.c .
> 
> I think modified sources are now polling well.
> 
> Hitoshi
> 
> This is a good refactor to reduce the initialization code to a single
> point of implementaton, and then just call that code from each of the
> modules to setup proper state

I futzed around for a while getting this to build with i386
allmodconfig but then got a bit tired of it.

Version 2, please ;)
