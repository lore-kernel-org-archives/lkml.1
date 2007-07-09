Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbXGIGsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbXGIGsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 02:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbXGIGrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 02:47:55 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:38992 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbXGIGry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 02:47:54 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Mon, 9 Jul 2007 08:47:42 +0200
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707081517540.11049-100000@netrider.rowland.org> <1183929611.3388.303.camel@localhost.localdomain>
In-Reply-To: <1183929611.3388.303.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707090847.43378.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 8. Juli 2007 schrieb Benjamin Herrenschmidt:
> > But I'm not sure it's a good idea in the long run.  Think of a printer 
> > daemon, for example.  It shouldn't have to experience unexpected I/O 
> > problems merely because someone has decided to put the system to sleep.
> 
> Why not ? Printer is offline when machine is asleep... trying to print

Not necessarily. The machine must survive going to sleep while you are
printing. Any other error return than -ERESTARTSYS is not an option.
We can't simply change the ABI.

	Regards
		Oliver

