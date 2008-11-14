Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYKNNHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYKNNHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKNNHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:07:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41416 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYKNNHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:07:39 -0500
Date: Fri, 14 Nov 2008 14:17:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] HID: don't grab devices with no input
Message-ID: <20081114131701.GI3810@one.firstfloor.org>
References: <491CA495.7010007@gmail.com> <1226614221-17118-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811141201450.19853@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811141201450.19853@jikos.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:02:27PM +0100, Jiri Kosina wrote:
> On Thu, 13 Nov 2008, Jiri Slaby wrote:
> 
> > Some devices have no input interrupt endpoint. These won't be handled
> > by usbhid, but currently they are not refused and reside on hid bus.
> > Perform this checking earlier so that we refuse to control such
> > a device early enough (and not pass it to the hid bus at all).
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> As the patch is obviously correct(tm) :) I have queued it in my tree, but 
> Andi, please still report back whether it fixes the issue you are seeing.

sispm works again with that patch. Thanks.

The only nit I noticed is that the error message seems to miss an \n

-Andi
