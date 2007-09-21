Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbXIUNaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbXIUNaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbXIUNaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:30:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:42029 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXIUNaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VN70AaJ6NATm3UItkqC6HSz4rXtnyEOaJJTMHUSd/xKYmXKv7bpDx1BmABkoXhwp2HDEXhQQ4+VD3dHgEyX3kCwU0/CF4YDKJBE1JFNohtyz5T/zrG6izjXiXypsel4lSaGlagAuGDzzhSK7mYRZ3FSB55sPrZzfZK3GVLIOc3Q=
Message-ID: <fbe8b1780709210630x492779f0s76322394467ff76b@mail.gmail.com>
Date: Fri, 21 Sep 2007 15:30:15 +0200
From: "Peter Stahlir" <peter.stahlir@googlemail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Git as a filesystem
Cc: "Muhammad Tayyab" <mail.tayyab@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0709211449370.30810@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com>
	 <46F3AAC1.5050409@gmail.com>
	 <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
	 <fbe8b1780709210446i24a7ee84reaa232be2d3d089e@mail.gmail.com>
	 <Pine.LNX.4.64.0709211449370.30810@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >For example, imagine running a complete Debian mirror on top of a
> >Debian system with gitfs. How big would the packfile be for this 252GB
> >beast?
>
> Probably 252 GB. Lots of the packages are already compressed, and
> each time a minimal change is done, the bytestream changes, so long
> story short, deltifying between to compressed streams is likely to
> deltify horribly.

What about adding deb or tar support to git?
Then git doesn't store deb archives but the contents of archives.
This way redundancy across architectures can be deltified.
