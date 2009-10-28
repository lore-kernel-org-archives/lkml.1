Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbZJ1EgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbZJ1EgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZJ1EgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:36:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbZJ1EgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:36:07 -0400
Date: Wed, 28 Oct 2009 05:36:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, airlied@gmail.com, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
Message-ID: <20091028043611.GK7744@basil.fritz.box>
References: <21d7e9970910271822p3751b2fdnd78e1bc3326b9b0b@mail.gmail.com> <87hbtkjkki.fsf@basil.nowhere.org> <20091027.203709.27104760.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027.203709.27104760.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 08:37:09PM -0700, David Miller wrote:
> On sparc64, in order to make debugging easier, we trap any time
> the kernel does a userspace access to a compat task and any
> of the upper 32-bits are non-zero.

Interesting. That definitely means Dave needs a special path.

> > However some architectures need special operations on compat pointers
> > (s390 iirc), but if you don't support those it might be reasonable
> > to not support that.
> 
> s390 has to sign extend all 32-bit compat process pointers when
> processing them in the 64-bit s390 kernel.  I think one other
> architecture has this kind of situation too.

Which other architure? I reviewed all the definitions in tree
and don't see any other than s390 doing magic there.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
