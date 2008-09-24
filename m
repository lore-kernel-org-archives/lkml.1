Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYIXUtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYIXUtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYIXUsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:48:03 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37543 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754884AbYIXUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:47:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VdYsl/cjbJwtrx3wEL6dMqIFiIIZAqglOxxrhZE14NyLeUknxuCXzg/bTzSj7O4/cSBR2YfQ9+wzqq1To4SagGqG7nomZBZJ0DPY/46BCVPcBM8185E2OHBv4MEPovEexHVyGf3QH16UgoxSgSPsYyV2gCNguP05k9imqfXkIHg=  ;
X-YMail-OSG: b9WZR0EVM1kmst7sRGWwxdOMpKPTkcqV0u0dzp8dwRfpvFtwtsLzaSamUCI8QdVXyPfo.9UdYft9zo1r_FA7yxj_PyHCT6aVp.owIhmsixuT9wzYh7_I.l3IjeJl0mRBJmMCiWTWbIIw.ift.NszhlxRzIqT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller driver
Date: Wed, 24 Sep 2008 13:15:26 -0700
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Scott Wood <scottwood@freescale.com>, greg@kroah.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Li Yang <leoli@freescale.com>
References: <Pine.LNX.4.44L0.0808281613540.3844-100000@iolanthe.rowland.org> <200808290027.59127.arnd@arndb.de>
In-Reply-To: <200808290027.59127.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241315.26794.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Arnd Bergmann wrote:
> If the gadget hardware drivers were registering the device with a
> gadget_bus_type, you could still enforce the "only one protocol"
> rule by binding every protocol to every device in that bus type.

And you'd have to rewrite all the gadget drivers ("protocol")
to work with multiple upstream ports.

That gets messy with e.g. the Ethernet links ... each would
need to be configured with unique ethernet address pairs.
Likewise with serial numbers.

I've learned to just accept complaints in this area as sort
of a price for existing.  It's all complaints, no patches.
So obviously the complaints don't have any requirements
backing them.  ;)

