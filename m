Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbYBNUuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbYBNUuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbYBNUuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:50:25 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54235 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759795AbYBNUuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:50:23 -0500
Date: Thu, 14 Feb 2008 21:50:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-ID: <20080214205031.GD21894@uranus.ravnborg.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au> <20080214202032.GB16545@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214202032.GB16545@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 12:20:32PM -0800, Greg KH wrote:
> On Fri, Feb 15, 2008 at 12:35:37AM +1100, Stephen Rothwell wrote:
> > 
> > So, comments, please.
> 
> Could you change the Makefile to show that if we build and run this
> tree, it really isn't Linus's tree?  Yes, I know the -git number will be
> different, but that might not be very obvious to people reading bug
> reports on lkml.
> 
> Just adding "-next" to the extraversion would be great.

A non-intrusive way to do so would be to add a file in the
top-level directory and name it localversion*.

For example:
echo '-next' > localversion-next

	Sam
