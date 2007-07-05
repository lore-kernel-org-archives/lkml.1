Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbXGEVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbXGEVPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759731AbXGEVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:15:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33943 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756213AbXGEVPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:15:25 -0400
Date: Thu, 5 Jul 2007 17:15:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: oliver@neukum.org, <pavel@ucw.cz>, <paulus@samba.org>,
       <johannes@sipsolutions.net>, <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <mjg59@srcf.ucam.org>, <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <E1I6YXX-0001yE-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0707051713440.2753-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Miklos Szeredi wrote:

> I fear, that your efforts to "save" the freezer are in vain.  It is
> already moderately hackish with that PF_FREEZER_SKIP and the kernel
> dotted randomly with try_to_freeze() calls, but adding bandaids to try
> to order freezing userspace processes in the right order would just
> make it a horrible mess.

I agree that bandaids won't work.  What's needed is something more 
radical.  Things like FUSE must be written so that the kernel parts 
_can_ freeze even while they are waiting for a response from a user 
thread.

Alan Stern

