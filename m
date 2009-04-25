Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZDYWFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZDYWFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZDYWFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:05:44 -0400
Received: from THUNK.ORG ([69.25.196.29]:37006 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZDYWFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:05:43 -0400
Date: Sat, 25 Apr 2009 18:05:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       npiggin@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/27] [rfc] vfs scalability patchset
Message-ID: <20090425220522.GA10248@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>, npiggin@suse.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090425012020.457460929@suse.de> <20090425041829.GX8633@ZenIV.linux.org.uk> <20090425080143.GA29033@infradead.org> <m1tz4ctuu7.fsf@fess.ebiederm.org> <20090425193133.GB8633@ZenIV.linux.org.uk> <m11vrgscj6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vrgscj6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 01:29:01PM -0700, Eric W. Biederman wrote:
> 
> I didn't trace it all of the way through but this comment in
> ext3_remount fooled me:
> 
> 	/*
> 	 * We have to unlock super so that we can wait for
> 	 * transactions.
> 	 */
> 
> Which was enough to think it might have been deliberate behavior so I figured
> it was worth asking.  It looked like the journal commit logic could have
> been doing the blocking magic to wait on ongoing truncates and the like.

Working on fixing this already for ext4.  Once we're convinced it's
right for ext4, we can backport the fixes for ext3.

      	  	       		    	      - Ted
