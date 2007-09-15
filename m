Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbXIOFzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbXIOFzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 01:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXIOFzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 01:55:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:4921 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbXIOFzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 01:55:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gov1bn2fghrnmqfKJmKa2AaWOrAw1fJrLdG1aaZBcHcQg6VvG1jAU2kS7VzI1TgBTkC5V0/fBXQQKQP3q/8RYxCGzYoHUGaS4P0fIygbN1CBXAhvTAmsPQuWbr2LU+eDPfVRCe6pbidT5spbel3bTI32cpu6hor1Jkzxsx0xA64=
Message-ID: <86802c440709142255p68768f7chf7d1f073c8a8937b@mail.gmail.com>
Date: Fri, 14 Sep 2007 22:55:00 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Cc: "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>, "Greg KH" <gregkh@suse.de>,
       "Matthew Wilcox" <matthew@wil.cx>, "Shaohua Li" <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <46EB1F16.8060209@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
	 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
	 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
	 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
	 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
	 <20070914151401.A5586@jurassic.park.msu.ru> <46EA9B23.7030709@shaw.ca>
	 <20070914192913.A6668@jurassic.park.msu.ru> <46EB1F16.8060209@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/07, Robert Hancock <hancockr@shaw.ca> wrote:
> It's not impossible at all. In fact I'm quite sure (Jesse can confirm)
> that in the case of the board he was using, it was an add-in graphics
> card where he saw this problem.
>
> The fact is that in the case of MMCONFIG overlap with PCI BARs, which
> one takes priority is completely undefined. In the case of this Intel
> chipset, clearly the PCI Express device connected to the northbridge had
> higher decode priority than the MMCONFIG aperture.

can you relocate the MMCONFIG above RAM range? for example 512G...

YH
