Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXFXXjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXFXXjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXFXXjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:39:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:10607 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXFXXjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iW8Yb45BNtMQg5maUATZsF4uZd2cgnEC40Dc8E9JYkh7/bsrJTAtY3MEci0jCoqTYovjtkzNOGfI+dXCzlWG9lI3rCrBBhviU4bVeMf0o+we9hbKLgEAeCl0I1KShSJjyZQkj4zrUChaKi5p/91eHY2slj/9VpNTpCf9sD/vxEc=
Subject: Re: [RFC] [PATCH 2.6.21.5] ppp: fix osize too small errors when
	decoding mppe
From: Konstantin Sharlaimov <konstantin.sharlaimov@gmail.com>
Reply-To: konstantin.sharlaimov@gmail.com
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, vsu@altlinux.ru, netdev@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070623.230702.60547745.davem@davemloft.net>
References: <4679116E.9050507@gmail.com>
	 <20070623.230702.60547745.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 10:38:41 +1100
Message-Id: <1182728324.8980.17.camel@traveler>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-23 at 23:07 -0700, David Miller wrote:

The original version of this fix have made it to the 2.6.22-rc5 already
and should be replaced with this one, however the two can coexist in the
same code for a while.

> > --- linux-2.6.21.3/drivers/net/ppp_generic.c.orig	2007-06-20 09:14:13.000000000
> > +1100
> > +++ linux-2.6.21.3/drivers/net/ppp_generic.c	2007-06-20 09:18:06.000000000 +1100
> 
> Please prevent your email client from corrupting patches like
> this by adding new lines.

Also, thank you for pointing this issue out, I'll fix it.

