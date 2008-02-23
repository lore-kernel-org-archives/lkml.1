Return-Path: <linux-kernel-owner+w=401wt.eu-S932841AbYBWI47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841AbYBWI47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYBWI4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:56:45 -0500
Received: from 1wt.eu ([62.212.114.60]:2099 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYBWI4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:56:44 -0500
Date: Sat, 23 Feb 2008 09:56:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
Message-ID: <20080223085634.GW8953@1wt.eu>
References: <200802221837.37680.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221837.37680.chase.venters@clientec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 06:37:14PM -0600, Chase Venters wrote:
> It seems to me that having multiple working trees (effectively, cloning 
> the "master" repository every time I need to make anything but a trivial 
> change) would be most effective under git as well as it doesn't require 
> creating messy, intermediate commits in the first place (but allows for them 
> if they are used). But I wonder how that approach would scale with a project 
> whose git repo weighed hundreds of megs or more. (With a centralized rcs, of 
> course, you don't have to lug around a copy of the whole project history in 
> each working tree.)

Take a look at git-new-workdir in git's contrib directory. I'm using it a
lot now. It makes it possible to set up as many workdirs as you want, sharing
the same repo. It's very dangerous if you're not rigorous, but it saves a lot
of time when you work on several branches at a time, which is even more true
for a project's documentation. The real thing to care about is not to have
the same branch checked out at several places.

Regards,
Willy

