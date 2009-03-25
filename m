Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbZCYTEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbZCYTEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZCYTEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:04:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45107 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbZCYTEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:04:38 -0400
Date: Wed, 25 Mar 2009 15:03:21 -0400
From: Bill Nottingham <notting@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Message-ID: <20090325190321.GB25176@nostromo.devel.redhat.com>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325190137.GA8509@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig (hch@infradead.org) said: 
> On Wed, Mar 25, 2009 at 03:00:46PM -0400, Bill Nottingham wrote:
> > scsi_wait_scan.ko is a bad interface for a variety of reasons:
> > - once you load it, it stays in memory doing nothing
> > - if you need to call it again, you first need to check for the module
> >   and unload it first
> > - waiting for scsi scans shouldn't require module loading privleges in
> >   any case
> > 
> > This creates a simpler interface that doesn't require as much
> > scaffolding in userspace.
> 
> /proc/scsi/scsi is deprecated, plese don't add more features to it.

Then where is a better place to put this, as scsi_wait_scan.ko is
a ridiculous interface for userspace?

Bill
