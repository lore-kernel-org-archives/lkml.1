Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYHNSCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYHNSCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYHNSCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:02:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49285 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbYHNSCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:02:08 -0400
Date: Thu, 14 Aug 2008 14:02:07 -0400
To: Ryan Hope <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Help writing kernel module...
Message-ID: <20080814180207.GC12476@csclub.uwaterloo.ca>
References: <48f7fe350808141100h3f368a53kb371e4cefea3e70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350808141100h3f368a53kb371e4cefea3e70@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 02:00:26PM -0400, Ryan Hope wrote:
> I can't find any information on how to make a kernel module load
> another module. Can someone please tell me how to do this? Thanks in
> advance.

Use a symbol exported by that other module and your module should
automatically depend on that module and modprobe will nicely load it
before your module for you.

-- 
Len Sorensen
