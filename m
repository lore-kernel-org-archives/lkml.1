Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbYHLCkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbYHLCkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 22:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYHLCj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 22:39:56 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:30603 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751200AbYHLCjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 22:39:55 -0400
Date: Tue, 12 Aug 2008 11:38:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] binfmt_elf_fdpic: Wire up AT_EXECFD, AT_EXECFN, AT_SECURE.
Message-ID: <20080812023854.GB9162@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>, dhowells@redhat.com,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080806103458.GE2610@linux-sh.org> <20080806103615.GC5194@linux-sh.org> <20080811141855.a4ddf04d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811141855.a4ddf04d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 02:18:55PM -0700, Andrew Morton wrote:
> On Wed, 6 Aug 2008 19:36:15 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > These auxvec entries are the only ones left unhandled out of the current
> > base implementation. This syncs up binfmt_elf_fdpic with linux/auxvec.h
> > and current binfmt_elf.
> 
> The patches ran afoul of the credentials changes in linux-next.
> 
> #1 and #2 applied OK, but #3 tossed the below reject.  Please check
> that my (fairly obvious) fixups are OK.
> 
Yes, your fixups look fine, thanks.

Also note that you are missing David's signed-off-by on 2/3:

http://marc.info/?l=linux-sh&m=121784461423443&w=2
