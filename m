Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZGMNU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZGMNU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 09:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZGMNU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 09:20:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44066 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbZGMNU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 09:20:58 -0400
Date: Mon, 13 Jul 2009 15:20:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andreas Schwab <schwab@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Vlasov <renton@renton.name>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Report file size for deleted files; was Re: Counters
	in df, du
Message-ID: <20090713132051.GA5168@basil.fritz.box>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> <20090713113252.GB5569@beaver.vrungel.ru> <20090713115917.GA27684@basil.fritz.box> <m3iqhwg1zu.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3iqhwg1zu.fsf@hase.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 03:13:09PM +0200, Andreas Schwab wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> >> But you can see the file date, these are new files and by next search
> >
> > I appended a patch that reports the size.
> 
> You can get the size already by using stat instead of lstat, ie. use ls -lL.

True, on the other hand you need two passes because that doesn't give
you file names. So the patch would be still more convenient.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
