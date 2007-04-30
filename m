Return-Path: <linux-kernel-owner+w=401wt.eu-S1423056AbXD3GBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423056AbXD3GBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 02:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423063AbXD3GBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 02:01:31 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:33045 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423054AbXD3GB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 02:01:29 -0400
X-YMail-OSG: DGv5zKIVM1nmz1f4yOPRwTsF3vHIB18l1eb1mqARs0tf8qBatECgPKeMGtte1rF9_Ftw_D5M5w--
Date: Sun, 29 Apr 2007 23:01:26 -0700
From: Chris Wedgwood <cw@f00f.org>
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070430060126.GA15038@tuatara.stupidest.org>
References: <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070430004702.GM32602149@melbourne.sgi.com> <20070430052559.GA13145@tuatara.stupidest.org> <20070430055632.GR32602149@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430055632.GR32602149@melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 03:56:32PM +1000, David Chinner wrote:
> On Sun, Apr 29, 2007 at 10:25:59PM -0700, Chris Wedgwood wrote:

> IIRC, the argument for FA_ALLOCATE changing file size is that
> posix_fallocate() is supposed to change the file size.

But it's not posix_fallocate; it's something more generic. glibc can
do posix_fallocate using truncate + fallocate.

> Note that the way XFS implements growing the file size after the
> allocation is via a truncate....

What's wrong with that?  That seems very reasonable.

> That's would what I did because otherwise you'd use ftruncate64().
> Without documented behaviour or an ext4 implementation, I have to
> ask what it's supposed to do, though ;)

How many *real* users are there for ext4?  Why does 'what ext4 does'
define 'the semantics'?

Surely semantics should be decided either by precedent (if there is an
existing relevant userbase) or sensible thought and some debate?
