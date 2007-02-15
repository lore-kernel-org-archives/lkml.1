Return-Path: <linux-kernel-owner+w=401wt.eu-S965846AbXBOKqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965846AbXBOKqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965844AbXBOKqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:46:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54868 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965843AbXBOKqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:46:18 -0500
Message-ID: <45D439F7.3030604@garzik.org>
Date: Thu, 15 Feb 2007 05:46:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Allen Martin <AMartin@nvidia.com>, nas@arctrix.com, B.Steinbrink@gmx.de
Subject: Re: sata_nv ADMA controller lockup investigation
References: <45D3E1FF.3080606@shaw.ca>
In-Reply-To: <45D3E1FF.3080606@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> It's curious that only the post-cache-flush command is having issues,
> and normal NCQ operation seems fine. Maybe it's related to that tag 0
> being reused repeatedly?


If you take cache flush out of the equation, what happens when NCQ is 
enabled with a queue depth of 1 (to reproduce tag-0-used-repeatedly 
condition)?

	Jeff


