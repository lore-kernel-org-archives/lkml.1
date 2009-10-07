Return-Path: <linux-kernel-owner+w=401wt.eu-S934331AbZJGQh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934331AbZJGQh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 12:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934323AbZJGQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 12:37:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45840 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934321AbZJGQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 12:37:57 -0400
Date: Wed, 7 Oct 2009 12:37:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: admin@prnet.org, <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.2 : error when ending apcupsd
In-Reply-To: <200910071323.34819.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0910071236470.2762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Oliver Neukum wrote:

> Am Mittwoch, 7. Oktober 2009 12:37:45 schrieb admin@prnet.org:
> > Hi,
> >
> > With kernel 2.6.31.2 I get the following error when I ending apcupsd:
> >
> > Oct  6 21:00:46 server apcupsd[5238]: apcupsd exiting, signal 15
> > Oct  6 21:00:46 server BUG: unable to handle kernel paging request at
> > ffff880130a6d858
> > Oct  6 21:00:46 server IP: [<ffffffff8124ba55>]
> > tty_port_close_start+0xc5/0x1d0
> 
> This looks like tty_port_close_start() is called with port == NULL
> And the new tty code went in with .2. I have to defer this to the Alans.

More context from the log, please.

Alan Stern

