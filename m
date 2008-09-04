Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbYIDOBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbYIDOBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYIDOBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:01:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54324 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbYIDOBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:01:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Thu, 4 Sep 2008 16:05:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200808291257.33690.rjw@sisk.pl> <200808291330.42265.elendil@planet.nl>
In-Reply-To: <200808291330.42265.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041605.22055.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, Frans Pop wrote:
> On Friday 29 August 2008, Rafael J. Wysocki wrote:
> > Suspend to RAM is fine, hibernation (aka suspend to disk) is not (on my
> > box). Does it mean that hibernation is fine on your box with
> > 2.6.27-rc5, although shutdown is not?  That would require special
> > DMI-dependent handling, so please double check.
> 
> Ah, right. The double spin down happens during hibernation too.
> 
> > Anyway, please attach the output of dmidecode to
> > http://bugzilla.kernel.org/show_bug.cgi?id=8855
> > so I can include your box into the final version of the patch.
> 
> Done.

I have uploaded a new version of the patch into the Bugzilla:
http://bugzilla.kernel.org/attachment.cgi?id=17618&action=view

Can you test it, please (also please attach dmesg output to the Bugzilla
entry)?

Thanks,
Rafael
