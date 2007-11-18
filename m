Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXKRRHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXKRRHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXKRRHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:07:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1356 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751031AbXKRRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:07:39 -0500
Date: Sun, 18 Nov 2007 12:07:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
In-Reply-To: <4740570A.5030101@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711181203220.5712-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2007, Jiri Slaby wrote:

> On 11/18/2007 04:23 PM, Rafał J. Wysocki wrote:
> > On Sunday, 18 of November 2007, Jiri Slaby wrote:
> >> On 11/18/2007 04:03 PM, Rafael J. Wysocki wrote:
> >>> Can you also make the new System-map available, please?
> >> Sure:
> >> http://www.fi.muni.cz/~xslaby/sklad/System.map1
> > 
> > The last notifier called in http://www.fi.muni.cz/~xslaby/sklad/susp_hang2.png
> 
> Last... Note, that it's only first 20 invokations of notifiers, there are
> bazillion of them when I remove the condition '< 20'.
> 
> > is apparently cpu_swap_callback() which is not called in
> > http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png .
> > 
> > Can you verify that cpu_swap_callback() gets called if the patch is not
> > applied?
> 
> Does this still apply?

You'll get more useful results if you redo your changes to 
notifier_call_chain().  Have it print out the address of the routine 
_before_ making the call, and don't limit it to 20.  That way you'll 
know exactly which notifier routine ends up hanging.

Alan Stern

