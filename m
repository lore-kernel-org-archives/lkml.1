Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKNNJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKNNJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYKNNJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:09:03 -0500
Received: from styx.suse.cz ([82.119.242.94]:50767 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289AbYKNNJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:09:01 -0500
Date: Fri, 14 Nov 2008 14:09:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
cc: Jiri Slaby <jirislaby@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] HID: don't grab devices with no input
In-Reply-To: <20081114131701.GI3810@one.firstfloor.org>
Message-ID: <alpine.LNX.1.10.0811141408440.19853@jikos.suse.cz>
References: <491CA495.7010007@gmail.com> <1226614221-17118-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811141201450.19853@jikos.suse.cz> <20081114131701.GI3810@one.firstfloor.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Andi Kleen wrote:

> > > Some devices have no input interrupt endpoint. These won't be 
> > > handled by usbhid, but currently they are not refused and reside on 
> > > hid bus. Perform this checking earlier so that we refuse to control 
> > > such a device early enough (and not pass it to the hid bus at all). 
> > > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> > As the patch is obviously correct(tm) :) I have queued it in my tree, but 
> > Andi, please still report back whether it fixes the issue you are seeing.
> sispm works again with that patch. Thanks.

Thanks a lot for testing.

> The only nit I noticed is that the error message seems to miss an \n

That I have already fixed in my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs
