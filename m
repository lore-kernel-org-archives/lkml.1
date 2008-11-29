Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYK2VPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYK2VPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYK2VPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:15:37 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41398 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752501AbYK2VPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:15:36 -0500
Date: Sat, 29 Nov 2008 16:15:33 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andres Freund <andres@anarazel.de>
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
Message-ID: <20081129211533.GG3372@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andres Freund <andres@anarazel.de>, adilger@sun.com,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
References: <200811291418.24672.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811291418.24672.andres@anarazel.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 02:18:19PM +0100, Andres Freund wrote:
> Hi Ted, Hi Andreas, hi all,
> 
> On a testsystem (spare laptop) with ext4 as root filesystem sometimes the 
> system starts to return ENOSPC to all write/create syscalls.
> Sometimes the system runs without problems, at other times it starts having 
> problems soon after boot.

Hmm.... Is there anything interesting log messages relating to ext4 or
jbd2 showing up in /var/log/messages or in dmesg?

     	     	   		     	   - Ted
