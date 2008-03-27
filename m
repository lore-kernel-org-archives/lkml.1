Return-Path: <linux-kernel-owner+w=401wt.eu-S1761199AbYC0Ueo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761199AbYC0Ueo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbYC0Uee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:34:34 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24067 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758210AbYC0Uee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:34:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ifQQnK0a8zR4M7kywucLn7EKA3LoRZITXr/81uGUecP2oWc0mewmPeL4fK018AEW4QNOALVTFunrq7nzNtFlCucfeDlMAT0xGrI5r1Xa2oawpIppOV1uRrZ+Nrk2Ea5Z71OvaVl9lzsZ9pc6OHsr40n5q29vTCJTCQ3Vo4fNWfY=  ;
X-YMail-OSG: KhCu1p8VM1m7QdJN8ZX8qxqTT3QguaHe60xiPe6rKnif9iUfg2GzcLwhSt_vOxhBd8SzyWF_Yw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mtd@lists.infradead.org
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Date: Thu, 27 Mar 2008 12:22:41 -0700
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, devzero@web.de,
       linux-kernel@vger.kernel.org,
       ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <212011377@web.de> <200803260010.25327.rjw@sisk.pl> <20080325164236.1061d403.akpm@linux-foundation.org>
In-Reply-To: <20080325164236.1061d403.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803271222.41579.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 March 2008, Andrew Morton wrote:
> 
> > > Mar 23 09:17:02 opensuse103 kernel: physmap-flash: probe of physmap-flash.0 failed with error -12
> 
> There are many physmap-flashes in the tree.  Is this one
> drivers/mtd/maps/physmap.c?

And there's a regression in mtd/maps/phsymap.c which should
be resolved before 2.6.25 ships ... on some platforms it
newly likes to oops on reboot.

I don't have a URL for that patch, but ISTR it's been
posted both to LKML and to linux-MTD.  (That doesn't
include less-good versions I've seen too.)  If needed,
I can dig it up, but I've been thinking this should have
a signoff from MTD folk.

- Dave

