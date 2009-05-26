Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZEZV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZEZV4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZEZV4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:56:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40050 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274AbZEZV4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:56:15 -0400
Date: Tue, 26 May 2009 17:56:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nigel Cunningham <nigel@tuxonice.net>
cc: Oliver Neukum <oliver@neukum.org>, <linux-pm@lists.linux-foundation.org>,
       <tuxonice-devel@lists.tuxonice.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [TuxOnIce-devel] [RFC] TuxOnIce
In-Reply-To: <1243373613.13930.61.camel@nigel-laptop>
Message-ID: <Pine.LNX.4.44L0.0905261754250.11998-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Nigel Cunningham wrote:

> USB devices ought to be able to do _something_ though - I have a Dvico
> Dual Digital 4 card

What is that?

> that is forcing me to shutdown X, mythtv-backend,
> pulse audio and lirc at the moment so that I can rmmod it while
> hibernating. That ought not be necessary. I'm sure there are good
> technical reasons why it is necessary at the mooment, but it shouldn't
> be that way - even if it just does the bare minimum required to avoid
> requiring the closing of files and the unload.

Probably the driver's author just never got around to adding support
for suspend/resume.  Which driver is it?  What happens if you don't 
rmmod it?

Alan Stern

