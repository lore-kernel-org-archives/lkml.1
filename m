Return-Path: <linux-kernel-owner+w=401wt.eu-S1761743AbXFRRay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743AbXFRRay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 13:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbXFRRap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 13:30:45 -0400
Received: from THUNK.ORG ([69.25.196.29]:42343 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXFRRao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 13:30:44 -0400
Date: Mon, 18 Jun 2007 13:29:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: alan <alan@clueserver.org>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618172955.GB24189@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, alan <alan@clueserver.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 09:16:30AM -0700, alan wrote:
> 
> I just wish that people would learn from the mistakes of others.  The 
> MacOS is a prime example of why you do not want to use a forked 
> filesystem, yet some people still seem to think it is a good idea. 
> (Forked filesystems tend to be fragile and do not play well with 
> non-forked filesystems.)

Jeremy Alison used to be the one who was always pestering me to add
Streams support into ext4, but recently he's admitted that I was right
that it was a Very Bad Idea.

As I mentioned in my Linux.conf.au presentation a year and a half ago,
the main use of Streams in Windows to date has been for system
crackers to hide trojan horse code and rootkits so that system
administrators couldn't find them.  :-)


						- Ted
