Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYHGQDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYHGQDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYHGQDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:03:32 -0400
Received: from outbound-mail-06.bluehost.com ([69.89.17.206]:54801 "HELO
	outbound-mail-06.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752631AbYHGQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:03:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=LYuvOiY3iqhrV0qZ0oTZyXklhPvWlMuXJ84YO6UpV9WoBYh3oimExoAMwPxOVQ2HsB6RDa9fhCQByiH+AjqOJ3fdhdlPm6y8K+mdjGoHRX9I+TzexJSQtnk2YdB9+ZxM;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>, greg@kroah.com
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Thu, 7 Aug 2008 09:03:22 -0700
User-Agent: KMail/1.9.9
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051415.59993.jbarnes@virtuousgeek.org> <1217973297.9923.80.camel@localhost.localdomain>
In-Reply-To: <1217973297.9923.80.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070903.23787.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 5, 2008 2:54 pm James Bottomley wrote:
> > or somesuch.  That seems just as simple for driver writers as your
> > initial patch, and the function is named in accordance with what it
> > actually does, rather than what it's used for...
>
> It could, but if the bridge is the culprit (as it usually is for MSI
> problems), this print won't help identify it.
>
> Therefore, rather than give driver writers a recipe for "print this and
> this and go to the bridge and print this", I'd rather have a single PCI
> callback that prints all the (hopefully) relevant information that will
> allow either fixing or blacklisting.

So in addition to the IRQ type check we need to dump some device topology 
information... yeah that makes sense.  I wonder if the driver core should 
provide something like this.  Greg?  In the meantime we can definitely add 
the IRQ type function.

Thanks,
Jesse
