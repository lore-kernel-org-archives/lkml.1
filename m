Return-Path: <linux-kernel-owner+w=401wt.eu-S1762448AbXGEVGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762448AbXGEVGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759995AbXGEVGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:06:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50302 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760030AbXGEVGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:06:09 -0400
Date: Thu, 5 Jul 2007 17:06:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, <pavel@ucw.cz>, <paulus@samba.org>,
       <johannes@sipsolutions.net>, <rjw@sisk.pl>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <mjg59@srcf.ucam.org>, <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <200707052249.45495.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0707051704580.2557-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007, Oliver Neukum wrote:

> > Obviously.  But I wasn't about the server trying to acquire a lock
> > held by a client.  I was talking about a client trying to acquire a
> > lock held by _another_ client.
> > 
> > If this coincides with the server (or some other task which the server
> > is depending on) being frozen before the clients, the freezer has a
> > problem.
> 
> True, but that case can only happen if servers are frozen before clients.
> You don't need a full dependency graph. A simple set sequence of two
> classes of tasks will do.

Just to make things more complicated...  Since a server isn't
restricted in what it can do, what happens when one server depends on
another server?

Alan Stern

