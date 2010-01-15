Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0AOOqH (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757732Ab0AOOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:46:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41195 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755792Ab0AOOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:46:05 -0500
Date: Fri, 15 Jan 2010 09:46:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
cc: linux-kernel@vger.kernel.org, <dbrownell@users.sourceforge.net>,
        <linux-usb@vger.kernel.org>,
        <Reinhard.Tartler@informatik.uni-erlangen.de>
Subject: Re: [PATCH] obsolete config in kernel source (USB_GADGET_*)
In-Reply-To: <20100115134833.GD3321@faui49.informatik.uni-erlangen.de>
Message-ID: <Pine.LNX.4.44L0.1001150945230.5010-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Christoph Egger wrote:

> Hi all!
> 
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we're checking referential integrity between kernel KConfig
> options and in-code Conditional blocks.
> 
> 	The linux tree contains USB-Id assignment snippets for some
> USB Gadget drivers, which, as far as I can tell, never worked on
> mainline linux2.6 but either originate from seemingly long-dead
> third-party trees or were never ported from linux2.4.
> 
> 	As there has also seemingly never existed a way to select
> these configs in the KConfig system it might be time to get rid of
> them which would be done by the attached patch.
> 
> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

Have you tried building g_file_storage and the other gadget drivers 
after applying your patch?

Alan Stern

