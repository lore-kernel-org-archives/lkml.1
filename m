Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbXIIP3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbXIIP3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 11:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbXIIP3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 11:29:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45134 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481AbXIIP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 11:29:36 -0400
Message-ID: <46E4115E.7050203@garzik.org>
Date: Sun, 09 Sep 2007 11:29:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
References: <20070909145358.GG6809@parisc-linux.org> <11893498072821-git-send-email-matthew@wil.cx>
In-Reply-To: <11893498072821-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Rearrange a lot of the functions in the file to get rid of all the forward
> declarations.

What thoughts, if any, have been given to post-patch code arrangement, 
besides eliminating prototypes?

This always struck me as a counterproductive exercise when taken by 
itself.  Sure, prototypes were eliminated, but was code packed together 
in an efficient way afterwards?  Ideally hot path code should be close 
together, ditto for various other things like error handling code.

Without further explanation or details about your post-patch analysis, 
how do we even know the new code arrangement doesn't negatively impact 
i-cache overall?

	Jeff


