Return-Path: <linux-kernel-owner+w=401wt.eu-S938345AbXHJPLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938345AbXHJPLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935111AbXHJPK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:10:27 -0400
Received: from z2.cat.iki.fi ([212.16.98.133]:59859 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937746AbXHJPKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:10:24 -0400
Date: Fri, 10 Aug 2007 18:10:14 +0300
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Vlad <vladc6@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Noatime vs relatime
Message-ID: <20070810151014.GT6372@mea-ext.zmailer.org>
References: <233939.75965.qm@web54403.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <233939.75965.qm@web54403.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 07:26:46AM -0700, Vlad wrote:
... 
> "Warning: Atime will be disabled by default in future kernel versions,
> but you will still be able to turn it on when configuring the kernel."
> 
> This should give a heads-up to the 0.001% of people who still use
> atime so that they know to customize this option or start using modern
> file-monitoring techniques like inotify.

NO for two reasons:
  - atime semantics are just fine in server environments
  - inotify IS NOT scalable to millions of files, nor
    to situations where we want to check alteration weeks
    or months after the fact

In reality I would perhaps prefer mount-behaviour being altered
from 'by default do atime' to 'by default do noatime.

There MUST be an easy way to tell system that "yes, I want to track
last accesstime."


I did recently an embedded Linux PC system where the entire
system disk is a single Compact Flash -card.  I tried to play
with  noatime  option, but the system still kept writing things,
and thus I had to do full and somewhat drastic  read-only.


> Vlad

/Matti Aarnio
