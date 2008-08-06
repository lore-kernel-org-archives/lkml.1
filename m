Return-Path: <linux-kernel-owner+w=401wt.eu-S1761634AbYHFU2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634AbYHFU2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbYHFU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:27:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60638 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754558AbYHFU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:27:48 -0400
Date: Wed, 6 Aug 2008 16:27:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Simon Arlott <simon@fire.lp0.eu>, Rene Herman <rene.herman@keyaccess.nl>,
       <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
In-Reply-To: <20080806131729.6384550c@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0808061626520.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Arjan van de Ven wrote:

> > > > Why is 5 seconds too long?  Too long for what?
> > > 
> > > because I'm done booting to full UI in that time.
> > > 
> > > it's forever.
> > 
> > This doesn't answer my question.  Why does the fact that you're
> > already in the UI after 5 seconds mean that 5 seconds is too long to
> > delay the start of khubd?
> 
> 
> because it means that while the rest of boot is done and the system
> idle, the mouse and keyboard aren't going to work.

Ah, okay.  Then if the delay time were set up as a module parameter, 
you'd be one of the people who leaves the parameter set at its default 
value of 0.

Alan Stern

