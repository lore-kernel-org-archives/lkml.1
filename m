Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbYEUObc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbYEUObc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYEUObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:31:22 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:38271 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbYEUObV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:31:21 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: fix deadlock in HCD code
Date: Wed, 21 May 2008 16:31:15 +0200
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805211005071.2490-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805211631.16364.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 21 Mai 2008 16:13:45 schrieb Alan Stern:
> > usb_hcd_flush_endpoint() is an obvious case.
> 
> It's not obvious to me.  Where does usb_hcd_flush_endpoint() acquire 
> hcd_urb_list_lock with interrupts enabled?

Sorry, yes looking again, it does complicated stuff with dropping the
lock but leaving interrupts disabled.

	Sorry
		Oliver

