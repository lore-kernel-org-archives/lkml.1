Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYA3HRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYA3HRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 02:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYA3HRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 02:17:08 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:43284 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764AbYA3HRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 02:17:06 -0500
Date: Wed, 30 Jan 2008 02:11:23 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
Message-ID: <20080130071123.GF21944@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1JJjMo-00011j-EU@closure.thunk.org> <20080129125307.GF6774@mit.edu> <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 10:54:03PM +0100, Jan Engelhardt wrote:
> 
> On Jan 29 2008 07:53, Theodore Tso wrote:
> >
> >>fwiw, diffstat is confused by git's diff output; you need to use
> >>'diffstat -p1'
> 
> I am seeing normal behavior:
>
> 22:52 sovereign:~/linux > git diff HEAD | diffstat

That's because you are doing a diff stat of changes that haven't been
checked in yet.  I was doing a "git log -p origin.. | diffstat -p1",
and in that incantation you definitely do need the -p1 to diffstat.

       	    		    	       	  - Ted
