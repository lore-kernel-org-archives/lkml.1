Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXEJXru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXEJXru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXEJXrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:47:43 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33699 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbXEJXrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:47:42 -0400
Message-ID: <4643AF19.5080309@garzik.org>
Date: Thu, 10 May 2007 19:47:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <46431D19.1070308@rtr.ca> <46434AE5.8060605@garzik.org> <46438FAC.1030702@rtr.ca> <464391B3.7040708@garzik.org> <4643AB76.1000408@shaw.ca>
In-Reply-To: <4643AB76.1000408@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> I don't think this is as big of a deal here as in other cases, like oops 
> output. With libata errors, if they're at the console (which they'd have 
> to be to see these messages), unless something has actually caused a 
> panic the scrollback buffer should still be functional and they'd be 
> able to see the entire output..


Scrollback rarely works as planned, for me.  Overall, a balance must be 
found.

More information is more helpful.  But.

There are downsides to spewing everything possible, upon error.  You 
cause logging to the possibly problematic disk, you push older messages 
out of the printk ring buffer, etc., etc.

	Jeff


