Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbYACDvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbYACDvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYACDuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:50:44 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:46493 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753378AbYACDun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:50:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BS3U2cpziTYaKM5LI4xJOM7xd2lfkY/G9XaiS0nmrGmMimebTIJtl+6eztQ4x3d+v5DrDYxkTVihfQeyyfeZ2NW2HKU31sd0LVCTxHhU5+sTKCln3hUrx0zYXQ8F4xJYyByMndGrK7mFo6YRuXeI9L+qVBpFxpQ5TLkiUdd9Cew=  ;
X-YMail-OSG: g9DAvNgVM1n560m00hZ8hVDaSJQgTq3aBu_GJlpIetqFK9ChX4O3Qbecj7Lbq6VPJ4XLZN7P1A--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 19:50:36 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, Mike Frysinger <vapier.adi@gmail.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
References: <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021556070.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801021950.36677.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Alan Stern wrote:
> 
> > The transaction translators in external high speed hubs require
> > hosts to issue particular USB transactions.  If the host controller
> > doesn't implement the that split transaction support, then it won't
> > be supporting external hubs.
> 
> So in theory one could connect a high-speed hub to such a host
> controller and expect it to communicate with high-speed devices.  So
> long as no full- or low-speed devices are added there wouldn't be any
> split transactions.  It wouldn't be USB-2.0 compliant but it should
> still work.

Yes ...

But that would be a nightmare in terms of support calls.  Take
two USB trees, and swap the hub ... suddenly one of the downstream
devices (the full speed one) starts (or stops!) working!  That's
not the sort of issue any support line wants to cope with on a
day-to-day basis.

The accounting for those products is often along the lines of:
if you got a support call, you didn't profit from that sale.
(And from the user perspective it's just a PITA and waste of
time.)  So *every* confusion like that one gets removed.

- Dave
