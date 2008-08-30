Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYH3Fpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYH3Fpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYH3Fp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:45:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:45384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbYH3Fp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:45:27 -0400
Date: Fri, 29 Aug 2008 22:43:43 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kobject leak in next-20080829
Message-ID: <20080830054343.GA16899@suse.de>
References: <20080830044246.GA26435@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830044246.GA26435@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 08:42:46AM +0400, Alexey Dobriyan wrote:
> 	size-32: 3511 kvasprintf+0x57/0x90
> 	size-64: 3059 kobject_create+0x1c/0x40
> 
> These two buddies increase after every "modprobe; rmmod" sequence.

Do they also do so in mainline?

thanks,

greg k-h
