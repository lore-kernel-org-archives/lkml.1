Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbZDOOZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbZDOOZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZDOOZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:25:09 -0400
Received: from rtr.ca ([76.10.145.34]:55027 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZDOOZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:25:07 -0400
Message-ID: <49E5EE41.3090505@rtr.ca>
Date: Wed, 15 Apr 2009 10:25:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
References: <49E4FAC6.1030400@garzik.org> <20090415014930.GA29413@kroah.com> <49E5480F.10501@garzik.org> <20090415050947.GB3462@kroah.com>
In-Reply-To: <20090415050947.GB3462@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> ..
> The issue is that you were just lucky that your machine worked properly
> previously.  My boxes with the same type of setup didn't, so I quickly
> realized what the root delay boot option was for.  You need to just do
> the same thing here, there's nothing else we can do.
..

Bad excuse.

SATA drives also take variable amounts of time to "show up" at boot.
Perhaps Jeff should customize libata for your and Arjan's exact setups,
just to help with understanding the point here.  :)

The speed ups are fine (and welcome), but we really now need
Arjan to follow-up with a patch to have the kernel *by default*
wait a little longer for the rootfs to show up.

Not forever, just a few seconds to compensate for the regression.
