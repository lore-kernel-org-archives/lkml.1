Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbZE0CNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbZE0CNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 22:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbZE0CNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 22:13:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34978 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751147AbZE0CNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 22:13:37 -0400
Date: Tue, 26 May 2009 22:13:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
In-Reply-To: <1243376885.17847.15.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0905262210350.21274-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Benjamin Herrenschmidt wrote:

> On Tue, 2009-05-26 at 10:06 -0400, Alan Stern wrote:
> > On Tue, 26 May 2009, Benjamin Herrenschmidt wrote:
> > 
> > > Well, both our patches are bogus in the sense that they will leak
> > > the stuff in the port structure.
> > 
> > That's not true at all.  Take a look at the destroy_serial() routine.
> 
> Right... hrm. This is an horrible mess, I can't wait to see that
> refcount going wrong and things trying to double free or leaking the
> structure.
> 
> Oh well, fix it the way your want, I don't care as long as it's fixed.
> This driver is just plain horrible.

I can't disagree with that.  :-)  The usb-serial design was a mess to 
begin with, and it didn't get much better when the serial bus was 
introduced.

I'm inclined to use my patch because it's shortest.  Can I add your 
"Tested-by:"?

Alan Stern

