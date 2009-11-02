Return-Path: <linux-kernel-owner+w=401wt.eu-S932325AbZKBUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbZKBUBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 15:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932291AbZKBUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 15:01:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932189AbZKBUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:01:04 -0500
Date: Mon, 2 Nov 2009 11:58:02 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Qinghuang Feng <qhfeng.kernel@gmail.com>
Subject: Re: [PATCH 25/27] BKL: Remove BKL from sysfs
Message-ID: <20091102195802.GA14201@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-26-git-send-email-jblunck@suse.de> <20091102164417.GA21592@suse.de> <20091102173543.GI21750@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091102173543.GI21750@bolzano.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 06:35:43PM +0100, Jan Blunck wrote:
> On Mon, Nov 02, Greg KH wrote:
> 
> > On Mon, Nov 02, 2009 at 11:05:05AM +0100, Jan Blunck wrote:
> > > BKL is only used in fill_super and get_sb_single() is used. It is safe to
> > > remove it.
> > > 
> > > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Is this going through your tree to Linus, or do you want me to take this
> > patch through mine?
> 
> I guess this should go through tip since there are already other bkl removal
> patches in per-topic branches there.

Ok, no objection from me.

thanks,

greg k-h
