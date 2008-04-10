Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYDJVQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYDJVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYDJVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:16:50 -0400
Received: from ns.suse.de ([195.135.220.2]:55335 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYDJVQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:16:50 -0400
Date: Thu, 10 Apr 2008 14:12:36 -0700
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UIO: hold a reference to the device's owner while
	the device is open
Message-ID: <20080410211236.GA21251@suse.de>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410210229.GF3193@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410210229.GF3193@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 11:02:29PM +0200, Hans J. Koch wrote:
> On Thu, Apr 10, 2008 at 02:37:00PM +0200, Uwe Kleine-K??nig wrote:
> > Otherwise the device might just disappear while /dev/uioX is being used
> > which results in an Oops.
> 
> Hi Uwe,
> thanks for this one, good catch! Looks fine to me. There are some minor issues, see
> below.
> And I'd like to hear Greg's opinion: Do you agree we can omit
> try_module_get() in uio_mmap()?

If it's already been grabbed in the open() call, everything should be
safe, right?

thanks,

greg k-h
