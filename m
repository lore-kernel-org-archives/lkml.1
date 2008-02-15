Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbYBOHlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbYBOHlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 02:41:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYBOHks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 02:40:48 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49001 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbYBOHk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 02:40:27 -0500
Date: Fri, 15 Feb 2008 09:40:09 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] let DEBUG_SECTION_MISMATCH depend on BROKEN
Message-ID: <20080215074009.GA4772@cs181133002.pp.htv.fi>
References: <20080215005648.GK23227@cs181133002.pp.htv.fi> <20080215073306.GA28588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080215073306.GA28588@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 08:33:06AM +0100, Sam Ravnborg wrote:
> On Fri, Feb 15, 2008 at 02:56:48AM +0200, Adrian Bunk wrote:
> > The pattern for making a config option on purpose not available is a 
> > dependency on BROKEN.
> BROKEN says that what is selected by the cofig option
> is broken.
> This is not the case for DEBUG_SECTION_MISMATCH which is
> why it was made dependent on something else.

BROKEN is our pattern for "intentionally disabled".

I did really grep for UNDEFINED when I first saw it since it might as 
well have been some kind of CONFIG_UNDEFINED "warn about undefined foobar".

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

