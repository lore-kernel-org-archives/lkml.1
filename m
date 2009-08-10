Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZHJXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZHJXSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZHJXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:18:35 -0400
Received: from kroah.org ([198.145.64.141]:36092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbZHJXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:18:34 -0400
Date: Mon, 10 Aug 2009 15:08:56 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anthony Wong <awong1@novell.com>
Subject: Re: linux-next: staging series import warning
Message-ID: <20090810220856.GA27402@kroah.com>
References: <20090810102443.3bc514b9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810102443.3bc514b9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 10:24:43AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> The import of the staging series produces these warnings (among others):
> 
> staging-add-realtek-8192-pci-wireless-driver.patch
> quilt-tmp/.git/rebase-apply/patch:94: trailing whitespace.
> #ifndef __INC_DOT11D_H
> quilt-tmp/.git/rebase-apply/patch:95: trailing whitespace.
> #define __INC_DOT11D_H
> quilt-tmp/.git/rebase-apply/patch:96: trailing whitespace.
> 
> quilt-tmp/.git/rebase-apply/patch:97: trailing whitespace.
> #ifdef ENABLE_DOT11D
> quilt-tmp/.git/rebase-apply/patch:98: trailing whitespace.
> #include "ieee80211.h"
> warning: squelched 21645 whitespace errors
> warning: 21650 lines add whitespace errors.
> 
> This might be a good place for someone to consider starting cleaning
> up ...  :-)

Ah crap, I got the wrong line-ends for some of those files, sorry about
that, I'll go clean it up...

greg k-h
