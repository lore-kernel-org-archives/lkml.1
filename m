Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbXLRPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbXLRPeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbXLRPe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:34:29 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:21908 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbXLRPe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:34:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KuQyrRVSjiybArTQy5rER7TQCBeF6sN+aO37VnIgogMDBJglECzAd/C8jWm6xq0fQLvRCkLt+21z3xVJt62Gmnrqx3SoLSmpP8Bwst175WNC9LYaG5fB3W+kzVVFma40av2En72vhcLzk/LvSUYGoYTckqDvLzucUBEJ3kdBrxk=
Message-ID: <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>
Date: Tue, 18 Dec 2007 10:34:26 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Try uploading something through rsync+ssh, or scp+ssh. If it aborts
> or hangs after a while, that may be an strong indication of a crappy
> router. Also, I'd advise to upgrade to something newer like >=
> 2.6.22. There was one of those SACK-broken routers around here too,
> but it seemed to have been replaced (or linux got a mysterious fix
> :-) as one day when I tried turning off SACK, rsync didnot abort
> anymore on new connections.

Uploads to hosts other then 2000 being hit by my app via webservices
run flawlessly to completion.  I really don't think it is my routing
equipment- I've completely rebuilt the whole network infrastructure
several times in the 4 years that I've had this problem, have moved to
different colo facilities, and several other network related factors
and still have seen this problem.

It's very challenging for me to upgrade the kernel as this is a
production system and I need to run on whatever the latest RedHat
supports for support contract reasons.  I probably could do it if
there are specific fixes that there is reason to believe will make my
problem go away.


> Though, if SACK was the problem, the problem would be much more
> likely to appear after the handshake. YMMV.
