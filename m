Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbYKMXHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbYKMXHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYKMXHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:07:35 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:33028 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752054AbYKMXHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:07:34 -0500
Date: Thu, 13 Nov 2008 18:07:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
       dedekind@infradead.org, ext-adrian.hunter@nokia.com,
       linux-mtd@lists.infradead.org, dushistov@mail.ru, jmorris@namei.org
Subject: Re: [PATCH] filesystems: use has_capability_noaudit interface for
	reserved blocks checks
Message-ID: <20081113230717.GA25117@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	sct@redhat.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	dedekind@infradead.org, ext-adrian.hunter@nokia.com,
	linux-mtd@lists.infradead.org, dushistov@mail.ru, jmorris@namei.org
References: <1226430769.3353.5.camel@localhost.localdomain> <20081113145316.e53858bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113145316.e53858bd.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 02:53:16PM -0800, Andrew Morton wrote:
> On Tue, 11 Nov 2008 14:12:49 -0500
> Eric Paris <eparis@redhat.com> wrote:
> 
> > ext[2,3,4], ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
> > if they should allow reserved blocks to be used.  A process not having
> > this capability is not failing some security decision and should not be
> > audited.  Thus move to using has_capability_noaudit.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> > I would like to push this patch through the security tree (since that's
> > the only place the new cap_noaudit interface exists), but I'd like to
> > get an ACK from each subsystem maintainer.

For ext4:

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
