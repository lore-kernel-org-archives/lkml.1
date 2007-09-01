Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXIANnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXIANnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 09:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbXIANnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 09:43:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:55965 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXIANnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 09:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Y3iZtgOBD2bL4aFKusH2ZpqdYyqhJX8ERlSvACLk0RFvJcfj+z01ofM/l+Tx+5WEpOQtQyp8Qmeivc4J/l32zy+DbHsrFT+XDKg6ge3v5gs+BJwu8+KKJjlzCfL/rR89mBpFbLtK6H26ZcexIBUZmv2AXQMRa8V2runq+C/TBg4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: maturity and status and attributes, oh my!
Date: Sat, 1 Sep 2007 15:44:07 +0200
User-Agent: KMail/1.9.6
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <Pine.LNX.4.64.0709010648530.32589@localhost.localdomain> <46D947A3.1000404@garzik.org>
In-Reply-To: <46D947A3.1000404@garzik.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709011544.07732.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 September 2007, you wrote:
> Robert P. J. Day wrote:
> > On Sat, 1 Sep 2007, Jeff Garzik wrote:
> > 
> >> Feature deprecation and removal is a very amorphous concept that
> >> does not fit well at all into Kconfig markers, unlike
> >> experimental/broken.

The current approach (text file) is:
* centralized
* requires manual testing of all future changes
* totally invisible to the end-users (higly frustrating for them when
  they learn about scheduled changes when things brake)

The proposed approach (Kconfig) is:
* distributed
* allows partial automatic testing of future changes
* could be make visible to the end-users by smart use of macros/inlines
  and adding kernel parameter (would make users informed and encourage
  them to help with the development)

> > and, as i've said before, i disagree.  while one might debate what
> 
> Feel free to disagree -- I am describing how things play out on a day to 
> day basis.  In essence you are disagreeing with reality.

Part of the problem is that many people (including developers) learn about
things being deprecated/obsoleted after they are actually removed.

Of course things are not black and white and common sense is required but
moving in the Kconfig direction is an improvement IMO and could speed up
the development in the long-term.

BTW There is nothing wrong with disagreeing with the reality and trying
to change it.  If everybody would conform to the reality there will be no
progress at all... ;)

Bart
