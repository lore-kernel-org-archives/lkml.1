Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbYIFLCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbYIFLCl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 07:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYIFLCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 07:02:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYIFLCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 07:02:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp nx6325
Date: Sat, 6 Sep 2008 13:06:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org, trenn@suse.de,
       htejun@gmail.com, hancockr@shaw.ca, linux-kernel@vger.kernel.org,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>
References: <200808290002.55026.rjw@sisk.pl> <200809060118.38493.rjw@sisk.pl> <200809060209.37353.elendil@planet.nl>
In-Reply-To: <200809060209.37353.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809061306.48377.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 6 of September 2008, Frans Pop wrote:
> On Saturday 06 September 2008, Rafael J. Wysocki wrote:
> > Thanks.  There's a new patch for you to test in there already. :-)
> 
> Seems to work correctly. The first spindown no longer happens.
> 
> In the BTS you noted the support is "partial". What's partial about it?

I want the quirk to be only applied to on-board controllers and that wasn't
there yet for your system.

Updated patch (hopefully final) has been uploaded as:
http://bugzilla.kernel.org/attachment.cgi?id=17646&action=view

Thanks,
Rafael
