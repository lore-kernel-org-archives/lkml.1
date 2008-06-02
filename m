Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbYFBNir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbYFBNir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYFBNij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:38:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:18178 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbYFBNii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JyJurpTX3zGLKin6ZvK/2Ps3t3Qq5w2Ig2EcjHX3EbYWKQQ5m/0ATM6BxJKpNbO62px/LpCWY3C5Yo/UkJV6GIfiVD0G6m3+TyWCHtHZMJ5NsxE8WhmsrpAgiD9Q2zhMQflKVIvXfQJp8VlIkZrZBqSrYDuG1HvA1+IjOX2v7bA=
Message-ID: <7b9198260806020638y7bb5ff19l416b329b22528ba9@mail.gmail.com>
Date: Mon, 2 Jun 2008 14:38:37 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 1/2] vfs: Introduce on-demand filesystem initialisation
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20080601153205.GM28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212331915-22856-1-git-send-email-tspink@gmail.com>
	 <1212331915-22856-2-git-send-email-tspink@gmail.com>
	 <20080601153205.GM28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/1 Al Viro <viro@zeniv.linux.org.uk>:
> On Sun, Jun 01, 2008 at 03:51:54PM +0100, Tom Spink wrote:
>
>
> Occam's Razor...
>
> You've just serialized ->kill_sb() for given fs type (and made sure that
> if one gets stuck, _everything_ gets stuck).  Moreover, you've serialized
> sget() against the same thing (i.e. pretty much each ->get_sb()).
>
> All of that (and a couple of new methods) is done for something that just
> plain does not belong to VFS.  It's trivially doable in filesystem *and*
> it's about the objects with lifetimes that make sense only for filesystem
> itself.

Okay!  Thanks for reviewing, anyway. :-)

-- 
Tom Spink
