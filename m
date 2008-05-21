Return-Path: <linux-kernel-owner+w=401wt.eu-S935265AbYEUNhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935265AbYEUNhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764589AbYEUNgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:36:51 -0400
Received: from styx.suse.cz ([82.119.242.94]:42082 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763016AbYEUNgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:36:50 -0400
Date: Wed, 21 May 2008 15:36:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, lchiquitto@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: fix deadlock in HCD code
In-Reply-To: <200805211533.00221.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0805211533500.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805211405520.6718@jikos.suse.cz>
 <200805211521.01435.oliver@neukum.org> <Pine.LNX.4.64.0805211524130.6718@jikos.suse.cz>
 <200805211533.00221.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Oliver Neukum wrote:

> This turns out not to be the case. Interrupts are disabled.

You're right, this callchain can't cause the deadlock indeed. I'll go 
through the other possibilities.

To give some background to others reading this thread -- Leonardo (in CC) 
reported [1] that this patch fixes hard kernel hangs he has been seeing 
when using USB CDMA modem.

Still, we don't currently seem to see the place where the interrupts get 
enabled that makes the deadlock to trigger.

[1] https://bugzilla.novell.com/show_bug.cgi?id=378509

-- 
Jiri Kosina
SUSE Labs
