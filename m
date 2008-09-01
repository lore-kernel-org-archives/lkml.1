Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYIAHUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYIAHUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 03:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbYIAHUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 03:20:23 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:46202 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYIAHUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 03:20:21 -0400
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Mike Hommey <mh@glandium.org>
Cc: Tejun Heo <tj@kernel.org>, fuse-devel@lists.sourceforge.net,
       greg@kroah.com, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Subject: Re: [fuse-devel] [PATCHSET] CUSE: implement CUSE
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	<20080829055000.GB18930@glandium.org> <48B78EBA.609@kernel.org>
	<3bc8237c0808291150t2f18ba64vf445bdf4c2c8360c@mail.gmail.com>
	<48B93D68.6040506@kernel.org> <20080830185613.GC12546@glandium.org>
Date: Mon, 01 Sep 2008 09:20:19 +0200
In-Reply-To: <20080830185613.GC12546@glandium.org> (Mike Hommey's message of
	"Sat, 30 Aug 2008 20:56:13 +0200")
Message-ID: <87iqtggwng.fsf@frosties.localdomain>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+B1luDDY5HTyQBo3pIMYIa1pLO7a4dvBvoEX0c
	kDdWoSM06lXFWzaruaI2fr+YlUFgZDYWFvkmy8w23n0oHCT6So
	1R9swaXw8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Hommey <mh@glandium.org> writes:

> On Sat, Aug 30, 2008 at 02:30:32PM +0200, Tejun Heo wrote:
>> Yeah, compared to loopback over FUSE, anything would have less
>> problem. :-) I don't know much about nbd but it's pretty much solving
>> the same problem so I think it's logical to extend nbd including
>> giving it a new transport if necessary?  Or is there something
>> fundamentally better when it's done via FUSE?
>
> My gutt feeling is that it would have less overhead when done via FUSE
> than through nbd, but that could be wrong.
>
> Mike

What I would hope is that BUSE would add some zero copy transport in
there. A way to just redirect the BIOs from the BUSE device to other
block devices without copying the data around.

But maybe BUSE is a bad name for that. That would be more a DUSE -
Device mapper in USEr space.

MfG
        Goswin.
