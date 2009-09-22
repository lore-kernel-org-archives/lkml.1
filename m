Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbZIVUh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbZIVUh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 16:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZIVUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 16:37:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbZIVUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 16:37:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: kevin granade <kevin.granade@gmail.com>
Subject: Re: [PATCH] PCI PM: Read device power state from register after updating it (rev. 2)
Date: Tue, 22 Sep 2009 22:39:08 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>, linux-pci@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20090922080747.GA20853@rhlx01.hs-esslingen.de> <200909222150.01185.rjw@sisk.pl> <7004b08e0909221256m6d917531kc8b51e1af85d3459@mail.gmail.com>
In-Reply-To: <7004b08e0909221256m6d917531kc8b51e1af85d3459@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909222239.08255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, kevin granade wrote:
> On Tue, Sep 22, 2009 at 2:50 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday 22 September 2009, Andreas Mohr wrote:
> > > Hi Rafael,
> >
> > Hi,
> >
> > > first you say "returning an error code in such cases would..."
> > > and then the patch content has...?
> >
> > I don't quite understand your comment, care to elaborate?
> >
> >
> I think this is what was being referenced:
> 
> +       /* Return error code if we have failed to change the state */
> +       if (dev->current_state != state)
> +               dev_info(&dev->dev, "Refused to change power state, "
> +                       "currently in D%d\n", dev->current_state);
> 
> The comment says, "Return error code", where it should probably say, "Log
> error".  Or possibly no comment at all.

Ah, thanks.

Rafael
