Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbXFNOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbXFNOTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 10:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXFNOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 10:19:34 -0400
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:29047 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751429AbXFNOTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 10:19:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jyebz2UhjYXoNMgnMnffBBFTB0wwx0uj8dXOJuMKajAIRBUCw524dLkfXLR7511+GL5a2TZJjjc0a/8zvjfslqONKuZP5RG6Vw5TSeU6LHwldOaQGby4YAYcBebs8c9suw4/Hs4lQnxxiXzQ++v6lcwikKQbJnSo80HP47E1P/Y=  ;
X-YMail-OSG: pIXxzIcVM1k3N6ejgQ8nvLdxirV3JRZ7HX8wlXDjZ_b15hoVtMD.dFJ1Q67mI9g.XRfOZoD4hA--
From: David Brownell <david-b@pacbell.net>
To: Dmitry Torokhov <dtor@insightbb.com>
Subject: Re: [PATCH -mm 4/7] PM: Remove suspend and resume support from struct device_type
Date: Thu, 14 Jun 2007 07:19:28 -0700
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl> <3ae72650706131520m3091d04et31b1db64be692385@mail.gmail.com> <200706140010.03438.dtor@insightbb.com>
In-Reply-To: <200706140010.03438.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706140719.28829.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2007, Dmitry Torokhov wrote:
> On Wednesday 13 June 2007 18:20, Kay Sievers wrote:
> > Dmitry, you added this recently, is this used in any code you plan to
> > merge soon?
> >
> 
> Yes, I will need it to implement input device resume (mainly to restore LED
> state and repeat rate for keyboards).

Why wouldn't that use the class device suspend/resume mechanism?
