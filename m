Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYH1U5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYH1U5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 16:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbYH1U5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 16:57:39 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:32817 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510AbYH1U5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 16:57:38 -0400
Date: Thu, 28 Aug 2008 22:57:36 +0200
From: Andreas Mohr <andi@lisas.de>
To: "Leisner, Martin" <Martin.Leisner@xerox.com>, linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] select with timeout across S3
Message-ID: <20080828205736.GA11743@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

dito.

This also happened to me a couple (4?) months ago, likely on 2.6.24 or
2.6.25.
And for me it had the "very nice" effect of not obeying DHCP lease time,
with a red-faced IT guy appearing in my door the next morning thusly... ;)

>From examining it more closely, it was rather obvious that select timeout
happened maybe 10 hours later than it should have (with 12h lease time),
due to hitting nightly S2R about two hours into the lease time.
Annoying, to say the least.

I think I then privately asked some timer guy about it, but I didn't get
a reply.

The DHCP client to hit this was pump, IIRC (can re-check).

Andreas Mohr
