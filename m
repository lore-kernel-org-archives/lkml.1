Return-Path: <linux-kernel-owner+w=401wt.eu-S1762974AbXEKXW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762974AbXEKXW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXEKXWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:22:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44058 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbXEKXWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:22:48 -0400
Message-ID: <4644FAC4.4010809@garzik.org>
Date: Fri, 11 May 2007 19:22:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Tejun Heo <htejun@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add human-readable error value decoding
References: <46428103.3040003@shaw.ca> <4642E92D.5010509@gmail.com> <4643AAF6.7080204@shaw.ca> <46449E59.90608@redhat.com> <4644A3AD.7000700@gmail.com> <4644F7EC.3080607@shaw.ca>
In-Reply-To: <4644F7EC.3080607@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> The ATA ones are more of a pain in that regard than SCSI though - SCSI 
> has all distinct error codes for different errors, whereas ATA has 
> bitmasks for everything..

That should not affect implementation.  Either way, a table-driven 
approach can easily work.

I favor decoding the SError status bits, but your names were far too 
long.  "ProtocolErr" should be "Proto".  "10B8BErr" should be "10b8b". 
HostInternalErr to HostInt.  PHYInternalErr to PHYInt.  etc.

	Jeff


