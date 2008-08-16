Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYHPT2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYHPT2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYHPT15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:27:57 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:42228 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750930AbYHPT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:27:56 -0400
Date: Sat, 16 Aug 2008 15:27:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080816192749.GA8774@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <1218221293.15342.263.camel@think.oraclecorp.com> <1218747656.15342.439.camel@think.oraclecorp.com> <20080814234458.GD13048@mit.edu> <1218762627.15342.447.camel@think.oraclecorp.com> <1218804361.15342.470.camel@think.oraclecorp.com> <20080815134545.GM13048@mit.edu> <1218822772.15342.503.camel@think.oraclecorp.com> <20080815195941.GB22395@mit.edu> <1218832622.19495.14.camel@think.oraclecorp.com> <1218910210.19495.25.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218910210.19495.25.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 02:10:10PM -0400, Chris Mason wrote:
> 
> I tried just the writeback_index patch and got only 4 fragmented files
> on ext4 after a compilebench run.  Then I tried again and got 1200.
> Seems there is something timing dependent in here ;)
> 

Yeah, the patch Aneesh sent to change where we added the inode to the
dirty list was false lead.  The right fix is in the ext4 patch queue
now.  I think we have the problem licked and a quick test showed it
increased the compilebench MB/s by a very tiny amount (enough so that
I wasnt sure whether or not it was measurement error), but it does
avoid the needly fragmentation.

						- Ted
