Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXEZQHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXEZQHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXEZQHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:07:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:30008 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXEZQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VfIK06sUh9seegiloIDWz365W2hCTVE1jY7OPxaR8/t9O2yZFQ3rKx8TLr2EVZz0BNisyJErFV0lylxkwYSUhKSFd3UyIhiSYnUzrFB/uOupb26qHZnwTqj6XT85AN34pfRgSnFVoVNUdgAOnYUwC15Jje2mQYbyEmW5xbugdjk=
Message-ID: <2c0942db0705260907g4e37d4avcc652d2b7368edd5@mail.gmail.com>
Date: Sat, 26 May 2007 09:07:30 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Tommy Vercetti" <vercetti@zlew.org>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200705261746.01568@gj-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705261505.38109@gj-laptop>
	 <2c0942db0705260813g6aeedbfepc0afa94ba3550e5b@mail.gmail.com>
	 <200705261746.01568@gj-laptop>
X-Google-Sender-Auth: 81c29ceffce9057e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Tommy Vercetti <vercetti@zlew.org> wrote:
> in terms of driver, what do you mean ?

The software driver that handles the specific chipset for that drive.
The thing that shows up when you do an lsmod, assuming you have the
driver compiled as a module.

> /dev/hda:
>  Timing cached reads:   732 MB in  2.00 seconds = 365.74 MB/sec
>  Timing buffered disk reads:   76 MB in  3.00 seconds =  25.31 MB/sec

That looks fine. Your filesystem may just be very fragmented. I'm not
familiar with how reiser3 filesystems age, so if you've had the system
installed for quite some time, it may be time to back it up and
reinstall. Dunno.

All of Paolo's suggestions look good, BTW. Sorry I couldn't be more help.
