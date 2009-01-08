Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZAHEih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZAHEih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZAHEi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:38:27 -0500
Received: from genesysrack.ru ([195.178.208.66]:34026 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbZAHEi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:38:26 -0500
Date: Thu, 8 Jan 2009 07:38:24 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Daniel Phillips <phillips@phunq.net>
Cc: Jamie Lokier <jamie@shareable.org>, tux3@tux3.org,
       Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20090108043824.GA16728@ioremap.net>
References: <200812301935.49303.phillips@phunq.net> <200901041710.12435.phillips@phunq.net> <20090105021357.GA1345@shareable.org> <200901071850.59565.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901071850.59565.phillips@phunq.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel.

On Wed, Jan 07, 2009 at 06:50:59PM -0800, Daniel Phillips (phillips@phunq.net) wrote:
> Suppose a file delete event is sent, the external indexer dutifully
> deletes its index entry for the file, then the machine crashes without
> completing the delete transaction.  On reboot, the file still exists
> but it has leaked from the index.  Ideas?

Sending delete event when delete is completed?
 
> > There was an extension to inotify posted a few months ago to do this.
> > Additional events when something becomes persistent.
> 
> Do you have a pointer?

Somthing like that
http://lkml.org/lkml/2008/11/25/272

As of VFS s file-system indexer: what if vfs could provide an interface
to the lower-level FS to get the event flow which could be used by the
userspace the same way it reads the file, and if no such operation is
upported by the filesystem falback to the whole dir rescan...

-- 
	Evgeniy Polyakov
