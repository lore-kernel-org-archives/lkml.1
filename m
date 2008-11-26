Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKZOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKZOea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYKZOeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:34:20 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36584 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbYKZOeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:34:19 -0500
Date: Wed, 26 Nov 2008 09:34:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext3: unwelcome journal abort
Message-ID: <20081126143416.GB17991@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>
References: <20081126071915.0decaf2c@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126071915.0decaf2c@bike.lwn.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 07:19:15AM -0700, Jonathan Corbet wrote:
> Twice now I've gotten the following with 2.6.28-rc3:
> 
> Nov 26 00:15:49 bike kernel: [282457.819704] __log_wait_for_space: no transactions
>
> I'm pulling the system up to -rc6 now, will yell if it happens again.
> Is there anything else I can be looking at in the mean time?

That should fix it.   The fix is in commit e219cca0 which was in -rc4.

     	    	      	      	    	   - Ted
