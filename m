Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbYGWRsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbYGWRsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 13:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYGWRr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 13:47:59 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51465 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbYGWRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 13:47:58 -0400
Date: Wed, 23 Jul 2008 13:47:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
Message-ID: <20080723174753.GL8826@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	systemtap@sourceware.org
References: <1216676595.3433.80.camel@localhost.localdomain> <y0mprp68zg9.fsf@ton.toronto.redhat.com> <1216698788.3433.116.camel@localhost.localdomain> <20080722115101.GB9508@redhat.com> <1216739683.3364.43.camel@localhost.localdomain> <y0mk5fd9a64.fsf@ton.toronto.redhat.com> <20080723014804.GA8826@mit.edu> <20080723041612.GA11191@redhat.com> <20080723162505.GJ8826@mit.edu> <1216831226.13159.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216831226.13159.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 12:40:26PM -0400, James Bottomley wrote:
> I'm not sure we'd want to do it with CTF either ... the only reason to
> have it in the kernel is if the kernel wants to use it.  Right at the
> moment with the dwarf, systemtap userspace is the only consumer, so it
> doesn't need to be in the kernel; I don't really see that changing with
> CTF.  I think dtrace does it because the D runtime is in-kernel so some
> of the run time typing needs the CTF.

As far as I understand things, all of that is done in userspace and
byte-compiled down to run in their simple DTrace VM.  The reason for
CTF being in the Open Slaris is for their kernel debugger (kmdb) and
so that a crash dump can be guaranteed to be easily analyzed.[1]

   	  	     	    	       	  - Ted

[1] http://blogs.sun.com/levon/entry/reducing_ctf_overhead

