Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbXEJXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbXEJXcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXEJXcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:32:13 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:20304 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXEJXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:32:12 -0400
Date: Thu, 10 May 2007 17:32:06 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] libata: add human-readable error value decoding
In-reply-to: <464391B3.7040708@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <4643AB76.1000408@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com>
 <46431D19.1070308@rtr.ca> <46434AE5.8060605@garzik.org>
 <46438FAC.1030702@rtr.ca> <464391B3.7040708@garzik.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Mark Lord wrote:
>> If we're compiling the messages into the kernel regardless,
>> then it doesn't really make much sense to NOT show all of them
>> on the error paths.
> 
> 
> Not true.  Uncontrolled message spewage inevitably results in critical 
> information scrolling off the screen, before a user can take a digital 
> photo of the output...  Or of users being confused by subsequent error 
> fallout (i.e. multiple oopses reporting problem).
> 
> Moderation and restraint still have roles to play...  :)
> 
>     Jeff

I don't think this is as big of a deal here as in other cases, like oops 
output. With libata errors, if they're at the console (which they'd have 
to be to see these messages), unless something has actually caused a 
panic the scrollback buffer should still be functional and they'd be 
able to see the entire output..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

