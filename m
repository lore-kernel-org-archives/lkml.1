Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbXE2VTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbXE2VTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXE2VTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:19:35 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36922
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXE2VTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:19:34 -0400
From: Rob Landley <rob@landley.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Date: Tue, 29 May 2007 17:19:18 -0400
User-Agent: KMail/1.9.1
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>
References: <200705272229.21263.rjw@sisk.pl> <9D3FC259-8391-4C2F-9F0F-AEF6CB3030E8@cam.ac.uk> <1180343171.4242.15.camel@lov.localdomain>
In-Reply-To: <1180343171.4242.15.camel@lov.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291719.20197.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 5:06 am, Kay Sievers wrote:
> Well, 10 seconds are just to short for userspace to react on some
> setups, from tiny boxes which are busy, to 512 CPU boxes enumerating
> thousands of devices, all had problems here. Any timeout for a
> firmware-request is just a broken concept, the request should wait
> forever, to be fulfilled or canceled from userspace when it's ready.

If it's spawning a new usermode helper process, then figuring out when to give 
up and exit is that process's job.  If it _can't_ exec usermode helper, then 
that should fail immediately.

Where does the timeout come in?

Rob
