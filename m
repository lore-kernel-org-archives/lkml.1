Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbYHGQsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbYHGQsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYHGQry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:47:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50938 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755438AbYHGQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:47:52 -0400
Date: Thu, 7 Aug 2008 12:47:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Emanoil Kotsev <deloptes@yahoo.com>
cc: Simon Arlott <simon@fire.lp0.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>,
       <mingo@elte.hu>, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <467461.53792.qm@web53212.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.0808071245320.2598-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Emanoil Kotsev wrote:

> Hi,
> 
> I'm using usb drive to boot from. I also use USB mouse and USB keyboard.
> 
> Indeed I have to put a delay in the init script in the initrd to
> delay and give time for the initialization. I found out by testing
> that this delay should be >5sec.

This is controlled by a module parameter.  Read the description of 
delay_use near the top of drivers/usb/storage/usb.c.

Alan Stern

