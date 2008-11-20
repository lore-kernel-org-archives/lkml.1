Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYKTWGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYKTWGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 17:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbYKTWFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 17:05:54 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:20653 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755993AbYKTWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 17:05:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XW4spw3BTTtWbdkHBBgA/fnXtCYbrD4B2PDlqnEdMDJxJ1r+2H/lwDdyY7lppH6O59R6RBn4fYT1GvbznAd9qbwKd2bCbxBJ6LWjTsfD/B4AOsBhTK2u8ofYfKiWLKMKXvITY6bZOVi08yREwaLtCGkEs/5ygRj3pIkr/0Fho/g=  ;
X-YMail-OSG: HGi1dMoVM1mWxLDQGp7SyWOYlGEt0HdAw.Ana_aE2Allt2bikb4y6gtChiKkYwjKAWA9Gvl6LucXDbHde4h21Hq6AQhIAZkxGu3gwasy2zS.gnbrd5LDrt.y9a9s4mLKdDj7tFrEwRJv8yoPg8v2sDYr
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.28-rc5] regulator: enable/disable refcounting
Date: Thu, 20 Nov 2008 14:05:51 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Mark Brown <broonie@sirena.org.uk>
References: <200811161144.46582.david-b@pacbell.net> <200811191412.41259.david-b@pacbell.net> <1227218280.585.40.camel@vega.slimlogic.co.uk>
In-Reply-To: <1227218280.585.40.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201405.51671.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008, Liam Girdwood wrote:
> On Wed, 2008-11-19 at 14:12 -0800, David Brownell wrote:
> > On Wednesday 19 November 2008, Liam Girdwood wrote:
> > > Both -rc5 patches applied.
> > 
> > How about the other two which seemed non-controversial?
> > 
> >   http://marc.info/?l=linux-kernel&m=122645403604873&w=2 (code shrink)
> >   http://marc.info/?l=linux-kernel&m=122645416305013&w=2 (attribute shrink)
> > 
> > Those were sent against RC4.
> 
> Both applied.

Great!  Now, I think I have some comments from Mark to respond to ...
He seems to be saying a new regulator_ops method is needed.

- Dave



