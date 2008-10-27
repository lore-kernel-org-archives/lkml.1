Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYJ0STl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYJ0STl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJ0STb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:19:31 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34548 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751058AbYJ0STa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:19:30 -0400
Date: Mon, 27 Oct 2008 14:19:28 -0400
From: Theodore Tso <tytso@mit.edu>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: general protection fault:  from release_blocks_on_commit
Message-ID: <20081027181928.GB23111@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
References: <1224612181.19719.20.camel@paris-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224612181.19719.20.camel@paris-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 02:03:01PM -0400, Eric Paris wrote:
> I can consistently get the below backtrace any time I try to shutdown my
> machine.  This machine has ext4 as it's root FS.  This is 100%
> reproducible.  I backed out commit
> 3e624fc72fba09b6f999a9fbb87b64efccd38036 and it fixed the problem.
> 
> This is a regression.

Can you send me your .config, please?  I'm trying to duplicate it on
my end.  

						- Ted
