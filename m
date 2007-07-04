Return-Path: <linux-kernel-owner+w=401wt.eu-S1760170AbXGDUuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170AbXGDUuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758731AbXGDUtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:49:47 -0400
Received: from thunk.org ([69.25.196.29]:60804 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972AbXGDUtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:49:45 -0400
Date: Wed, 4 Jul 2007 16:47:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Erik Mouw <mouw@nl.linux.org>
Cc: alan <alan@clueserver.org>, J?rn Engel <joern@logfs.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070704204759.GA341@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Erik Mouw <mouw@nl.linux.org>, alan <alan@clueserver.org>,
	J?rn Engel <joern@logfs.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int> <20070618140143.GD30244@thunk.org> <Pine.LNX.4.64.0706180907580.22137@blackbox.fnordora.org> <20070618172955.GB24189@thunk.org> <20070704173234.GB26201@gateway.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070704173234.GB26201@gateway.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 07:32:34PM +0200, Erik Mouw wrote:
> (sorry for the late reply, just got back from holiday)
> 
> On Mon, Jun 18, 2007 at 01:29:56PM -0400, Theodore Tso wrote:
> > As I mentioned in my Linux.conf.au presentation a year and a half ago,
> > the main use of Streams in Windows to date has been for system
> > crackers to hide trojan horse code and rootkits so that system
> > administrators couldn't find them.  :-)
> 
> The only valid use of Streams in Windows I've seen was a virus checker
> that stored a hash of the file in a separate stream. Checking a file
> was a matter of rehashing it and comparing against the hash stored in
> the special hash data stream for that particular file.

And even that's not a valid use.  All the virus would have to do is to
infect the file, and then update the "special hash data stream".  Why
is it that when programmers are told about streams as a potential
technology choice, it makes their thinking become fuzzy?  :-)

					- Ted
