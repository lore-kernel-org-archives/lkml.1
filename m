Return-Path: <linux-kernel-owner+w=401wt.eu-S934543AbYEUMe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543AbYEUMe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 08:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762057AbYEUMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 08:34:16 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:46388 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761994AbYEUMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 08:34:15 -0400
Date: Wed, 21 May 2008 08:32:55 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080521123255.GG8581@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080518211140.b29bee30.akpm@linux-foundation.org> <200805191316.27551.chris.mason@oracle.com> <200805191439.36577.chris.mason@oracle.com> <20080521112224.GD5028@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521112224.GD5028@ucw.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:22:25PM +0200, Pavel Machek wrote:
> 
> Ok, Andrew, is this enough to get barrier patch applied and stop
> corrupting data in default config, or do you want some more testing?

It is for me; I think we have to enable barriers for ext3/4, and then
work to improve the overhead in ext4/jbd2.  It's probably true that
the vast majority of systems don't run under conditions similar to
what Chris used to demonstrate the problem, but the default has to be
filesystem safety.  People who are sure they are extremely unlikely to
run into this problem can turn barriers off (and I suspect they won't
see that much difference in the most common workloads anyway).

    	      		    	     - Ted
