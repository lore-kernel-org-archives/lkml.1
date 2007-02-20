Return-Path: <linux-kernel-owner+w=401wt.eu-S965176AbXBTPwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176AbXBTPwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965179AbXBTPwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:52:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44059 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965176AbXBTPwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:52:31 -0500
Message-ID: <45DB193D.3070402@garzik.org>
Date: Tue, 20 Feb 2007 10:52:29 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sata_nv: add back some verbosity into ADMA error_handler
References: <45CFB624.9020201@shaw.ca>
In-Reply-To: <45CFB624.9020201@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Some debug output in the ADMA error_handler function was removed recently,
> but it may be useful in certain cases, like NCQ commands timing out. Add it
> back in, but make it a bit more intelligent so that it only prints if
> command(s) are active and only prints the CPBs for those commands.
> That way it won't spew at inappropriate times like suspend/resume.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied


