Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbZHBUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbZHBUut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZHBUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:50:49 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54382 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753467AbZHBUus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:50:48 -0400
Date: Sun, 2 Aug 2009 16:50:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Alex Riesen <raa.lkml@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.name>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Oops in CDC ACM after an Openmoko phone (neo1973) changes its
 usb  interface from ACM to Ethernet
In-Reply-To: <81b0412b0908021339s739c07edvd4d5eb4c21cfa167@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0908021650020.14120-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009, Alex Riesen wrote:

> Any idea how to disable stack dumps so that there is more place
> for other output on a laptop screen? (no chance for serial console)

Put a "return" statement at the start of dump_stack().

Alan Stern

