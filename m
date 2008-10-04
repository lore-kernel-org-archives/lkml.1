Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYJDW0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYJDW0J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYJDWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:25:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45516 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbYJDWZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:25:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/6] Hibernation: Introduce system_entering_hibernation
Date: Sun, 5 Oct 2008 00:30:17 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <20081004225008.2cc08201@lxorguk.ukuu.org.uk> <48E7E5B1.8010101@gmail.com>
In-Reply-To: <48E7E5B1.8010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810050030.18814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 4 of October 2008, Tejun Heo wrote:
> Alan Cox wrote:
> >> Hm, I'm not sure what you mean exactly, but the point is to blacklist the
> >> on-board controllers only and a devfn of the controller is needed for that,
> >> or a part of it (like the slot number I'm using).  Could that be done above
> >> the driver level?
> > 
> > It can be done in one place via the libata core code I think rather than
> > in each driver. Might need to be a helper function but you'd at least
> > remove all the duplication.
> 
> I think it's better to keep the list in each LLD but having a helper in
> libata-core would be nice.

Well, I can try to introduce one in a future patch.  Will that be OK?

Rafael
