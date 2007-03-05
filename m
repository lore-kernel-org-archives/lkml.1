Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXCES36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXCES36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCES36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:29:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbXCES35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:29:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Date: Mon, 5 Mar 2007 19:32:29 +0100
User-Agent: KMail/1.9.5
Cc: "Kristian =?iso-8859-1?q?Gr=F8nfeldt?= =?iso-8859-1?q?_S=F8rensen?=" 
	<kriller@vkr.dk>,
       linux-input@atrey.karlin.mff.cuni.cz,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <1172601905.5428.28.camel@localhost.localdomain> <1172781250.5042.1.camel@localhost.localdomain> <d120d5000703050644x741564v625f0aa7a58c60ad@mail.gmail.com>
In-Reply-To: <d120d5000703050644x741564v625f0aa7a58c60ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703051932.29996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 5 March 2007 15:44, Dmitry Torokhov wrote:
> On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > On Thu, 2007-03-01 at 15:25 -0500, Dmitry Torokhov wrote:
> > > On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > > >
> > > > Hmmm.
> > > >
> > > > Now i get this BUG:
> > > >
> > >
> > > Does it die the same way if you just unload the button driver without
> > > suspending?
> > >
> >
> > No. Tried unloading and loading 30 times after each other. No problems
> > at all.
> >
> 
> I wonder what causes unloading of the ACPI button driver during resume...

Let me guess: pm-utils in OpenSUSE 10.2.
