Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbXIKSDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbXIKSDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbXIKSDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:03:36 -0400
Received: from relais.videotron.ca ([24.201.245.36]:52250 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbXIKSDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:03:35 -0400
Date: Tue, 11 Sep 2007 14:03:34 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
In-reply-to: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
X-X-Sender: nico@xanadu.home
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Message-id: <alpine.LFD.0.9999.0709111333050.21186@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Requested by Jeff Garzik.
> 
> Add info about various email clients and their applicability
> in being used to send Linux kernel patches.
> 
> Some notes takes from http://mbligh.org/linuxdocs/Email/Clients
> Portions used with permission.

You should also have a look at the "MUA specific hints" section of 
Documentation/SubmittingPatches in the Git source distribution which 
contains additional hints.

> +Alpine (TUI)
> +
> +<I don't know.  Maybe Adrian or Linus can comment.>
> +
> +Are any special config options needed?

Alpine is the successor of Pine.  Issues that were found in some earlier 
Pine versions wrt patch sending are now fixed.

Here's the relevant config options. In the "Sending Preferences" 
section:

 - "Do Not Send Flowed Text" must be enabled

 - "Strip Whitespace Before Sending" must be disabled

When composing the message, the cursor should be placed where the patch 
should appear, and then pressing CTRL-R let you specify the patch file 
to insert into the message.


Nicolas
