Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXKKWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXKKWk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 17:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXKKWks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 17:40:48 -0500
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:16404 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788AbXKKWkr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 17:40:47 -0500
From: Frans Pop <elendil@planet.nl>
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Subject: Re: Bind mount bug?
Date: Sun, 11 Nov 2007 23:40:44 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200711111106.53494.elendil@planet.nl> <09A755B9-27C1-4B54-834C-FDA9EE806042@e18.physik.tu-muenchen.de>
In-Reply-To: <09A755B9-27C1-4B54-834C-FDA9EE806042@e18.physik.tu-muenchen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711112340.45400.elendil@planet.nl>
X-OriginalArrivalTime: 11 Nov 2007 22:40:45.0778 (UTC) FILETIME=[E6128B20:01C824B3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 November 2007, Roland Kuhn wrote:
> This mounts the bindtest/ tree on test/ _without_ copying the mount
> points which are found on subtrees.

Right. I guess this is the key point that tripped me up.

> So, you see, test/test/test/a was (as it should) physically created  
> in test/test, where it is shadowed by the bind mount as long as that  
> is not removed.

Which means that to continue the example from my follw-up mail:

> # ls bindtest/test
> foo
> # umount test
> # ls test
> foo
# umount bindtest/test
# ls bindtest/test
baz

And there indeed is the missing file.

> Nothing vanishes into "thin air" ;-)

Yeah, I saw that syntax error after sending the mail "into space" would have 
been OK too, but not my combining the two :-)

Thanks for the explanation!

Cheers,
FJP
