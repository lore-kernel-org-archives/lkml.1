Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYCYNvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYCYNvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYCYNvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:51:08 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:63072 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYCYNvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:51:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t70HEftM+S2+vvv31oy2vBZJr54AfZBUD7lTTAPcnqSi1kLNnQuZPb8gWFzQ0WBkjewJVqDZfYrwzpUah2ztKNu86h+tVhTbO2grx1GjN/vEc1pAQAFTDY1ms7grJCeUhf/3m182vaBer7nNXDap0eBRxSIJEV/nW3amgNBt7kY=
Message-ID: <87f94c370803250651k31000f99ia3e3dc98928590d4@mail.gmail.com>
Date: Tue, 25 Mar 2008 09:51:04 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jens Axboe" <axboe@kernel.dk>, "Jeff Garzik" <jgarzik@pobox.com>,
       "Tejun Heo" <htejun@gmail.com>, "Greg KH l" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <47E8FF58.8050209@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E875AD.1000901@rtr.ca>
	 <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org>
	 <47E8FF58.8050209@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 9:34 AM, Mark Lord <lkml@rtr.ca> wrote:
> Linus Torvalds wrote:
>
> >
>  > On Mon, 24 Mar 2008, Mark Lord wrote:
>  >> The return value uses "unsigned long",
>  >> which on a 32-bit system limits drive offsets to 2TB.
>  >
>  > One relevant question is: does anybody seriously care about the
>  > combination of "32 bit" and "huge modern drives" any more?
>  >
>  > Sure, we can add a 64-bit version that ends up being used only on 32-bit
>  > systems, but quite frankly, I think the solution here is to just ignore
>  > the issue and see if anybody really even cares.
>  >
>  > Because quite frankly, the kind of people who buy modern 2TB drives
>  > generally don't then couple them to CPU's that are five+ years old.

We provide data services to our clients.  We are already seeing USB
enclosures routinely provided to us by our clients with 1TB.  1.5TB on
occasion.  2TB usb enclosures can't be far behind.

For usb a bigger factor than anything is when will MS offer
compatibility/supportfor 2TB+ drives.  As soon as they become readily
supported in MS, our clients will start buying them and filling them
up and we will need to be able to access them from all of our systems.
(old and new).

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
