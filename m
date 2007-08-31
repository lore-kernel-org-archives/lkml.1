Return-Path: <linux-kernel-owner+w=401wt.eu-S965112AbXHaMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965112AbXHaMEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932756AbXHaMEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 08:04:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:52124 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbXHaMD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 08:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UyyhD2kDsdVmPtFDhAIOa1ytVsHsquNFY8UeLSlvyhUqQ+6C5QYdCNL1BVeiGmINk2YqFF5eBkmEJmw0hIwZ1J8gYnhA6w/RKshgf7z1OJMR572WC9Cvos5Ipxf7PvuLdcRXykiGfyfQV0A7SNR8h78xwktxjVdTpTuSDxct6uM=
Message-ID: <a4e6962a0708310503q5ec65485gd9025a44a57f89e1@mail.gmail.com>
Date: Fri, 31 Aug 2007 07:03:56 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [Lguest] [PATCH] modify lguest console to support multiple hvc's
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1188519575.6004.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11884991234068-git-send-email-ericvh@opteron.9grid.us>
	 <1188519575.6004.15.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Thu, 2007-08-30 at 13:38 -0500, Eric Van Hensbergen wrote:
> > From: Eric Van Hensbergen <ericvh@ericvh-desktop.austin.ibm.com>
> >
> > This was a quick modification I did of lguest to be able to support multiple
> > HVC channels for some experiments I was doing.  I'm not sure if this is more
> > generally useful, so I'm posting it to the list in case someone else has a
> > need for it.
> >
> > Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
>
>         This is cool!  Great that it's useful for you.  What do the other
> consoles look like from inside the guest?
>

They just show up on other hvc device minor numbers.  I was running 9p
over them, but I wanted a tighter coupling for v9fs so I could tune
performance and incrementally optimize.

             -eric
