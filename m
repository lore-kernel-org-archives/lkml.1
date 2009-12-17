Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbZLQAqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbZLQAqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZLQAqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:46:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35653 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZLQAqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:46:45 -0500
Date: Thu, 17 Dec 2009 00:46:43 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: devtmpfs [censored] oddities
Message-ID: <20091217004643.GR14381@ZenIV.linux.org.uk>
References: <20091216080431.GF14381@ZenIV.linux.org.uk> <20091217003922.GB4863@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217003922.GB4863@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 04:39:22PM -0800, Greg KH wrote:
> On Wed, Dec 16, 2009 at 08:04:31AM +0000, Al Viro wrote:
> > 	May I respectfully suggest that a blocking operation (such as
> > kstrdup with GFP_KERNEL, or grabbing a mutex, or, say it, pathname resolution)
> > is not quite the thing to do while holding an rwlock?
> > 
> > 	As it is, any device_add() is an embarrassingly obvious deadlock
> > waiting to happen...
> 
> Thomas has posted a patch to fix this now.
> 
> Sorry for not catching it sooner, we should just delete the rwlocks so
> no one tries to ever use it again.

Say again?  Why would we delete rwlocks?

-- 
If you stare into drivers/staging long enough, drivers/staging stares back at
you...
