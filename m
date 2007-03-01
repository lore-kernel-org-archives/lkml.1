Return-Path: <linux-kernel-owner+w=401wt.eu-S965160AbXCAPNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965160AbXCAPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 10:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965171AbXCAPNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 10:13:25 -0500
Received: from smtp.bulldogdsl.com ([212.158.248.8]:4706 "EHLO
	mcr-smtp-002.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965160AbXCAPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 10:13:24 -0500
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
Date: Thu, 1 Mar 2007 15:13:15 +0000
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <200703011339.52895.s0348365@sms.ed.ac.uk> <45E6E701.6000600@shaw.ca>
In-Reply-To: <45E6E701.6000600@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011513.15179.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 14:45, Robert Hancock wrote:
> This one seems a bit different. This time it's not related to NCQ vs.
> non-NCQ (this is a non-NCQ write here), it's in ADMA mode (so it's
> presumably not related to switching between ADMA and register mode,
> unless perhaps a flush cache or something executed just before), and
> from the CPB data it appears the command completed but the controller's
> registers aren't indicating that it has. Not sure if I've seen one like
> that before..
>
> How easily can you reproduce this?

It's the first one since -rc2, so apparently not easily. I'm more than willing 
to find loads that expose it, though, so I might try that this afternoon.

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
