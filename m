Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbXKMP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbXKMP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXKMP6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:58:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:20748 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbXKMP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QVUHSgNhnB5QxsXh8tIQ/rCE1GbfSOfIqNcNIA3GFQYfrC2JIeCMrFcjtTei0Pzc0WyBDlbHK4GQVC1Cnx1xSdNpO2D7ypG5scqRQRyNAF6mSL0Vec0OjDGosqAETPLWT3DtyqX91xkEyem+WzZpM+Cmfh2fXMEn63tH4aUBQsg=
Message-ID: <2c0942db0711130757g295add20re0ee423b84921d28@mail.gmail.com>
Date: Tue, 13 Nov 2007 07:57:54 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
Subject: Re: [BUG] New Kernel Bugs
Cc: "Mark Lord" <liml@rtr.ca>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <4739C1B0.8000803@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org>
	 <20071113.033946.114918709.davem@davemloft.net>
	 <20071113034916.2556edd7.akpm@linux-foundation.org>
	 <20071113.035824.40509981.davem@davemloft.net>
	 <20071113041259.79c9a8c5.akpm@linux-foundation.org>
	 <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca>
	 <4739C1B0.8000803@cateee.net>
X-Google-Sender-Auth: 3e9d57184bb6cd83
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 13, 2007 7:24 AM, Giacomo A. Catenazzi <cate@cateee.net> wrote:
> As a long time kernel tester, I see some problem with the
> newer "new development model". In the short merge windows,
> after to much time, there are to many patches.

I think the root issue there is that it's hard to get all testers to
run a bisect, but easy to ask them to test snapshots. Right now the
snapshots are generated nightly, but I think it would make more sense
if they were generated every N patches, for some value of N...

Of course, for that to really work, we have to ensure that the result
is always compilable, which has been getting better, but not perfect.

Ray
