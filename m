Return-Path: <linux-kernel-owner+w=401wt.eu-S1752651AbZDMQlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbZDMQlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZDMQlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:41:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42938 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751155AbZDMQlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:41:14 -0400
Date: Mon, 13 Apr 2009 17:39:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gwendal@google.com
Subject: Re: [PROPOSED] ata: Report 16/32bit PIO as best we can
Message-ID: <20090413173921.0880e16a@lxorguk.ukuu.org.uk>
In-Reply-To: <49E36939.2050402@garzik.org>
References: <20090409133221.18202.63779.stgit@t61.ukuu.org.uk>
	<49DDF1EB.2060200@rtr.ca>
	<20090409140857.578a9146@lxorguk.ukuu.org.uk>
	<49E36939.2050402@garzik.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 12:32:57 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> > I'm not sure sysfs helps much anyway - you have to open the device file
> > and keep it open while accessing the sysfs nodes anyway (something huge
> > numbers of apps hopelessly fail to do so)  
> 
> FWIW...  here is the sysfs work I referred to (in a message sent several 
> days ago in this thread)...
> 
> http://lwn.net/Articles/294608/

Which indeed shows the same problems. There is nothing to stop changes in
the rest of the topology from causing me to write to the sysfs at the
wrong moment and reconfigure/misconfigure a different object to the one
intended.

Alan
