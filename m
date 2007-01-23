Return-Path: <linux-kernel-owner+w=401wt.eu-S965135AbXAWV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbXAWV1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965156AbXAWV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:27:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50832 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965140AbXAWV1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:27:20 -0500
Message-ID: <45B67D93.5070904@pobox.com>
Date: Tue, 23 Jan 2007 16:26:43 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s2io bogus memset
References: <E1H9Ki4-0006pB-FK@ZenIV.linux.org.uk>
In-Reply-To: <E1H9Ki4-0006pB-FK@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> memset() after kmalloc() on size * 8 would better be on size * 8, not
> just size; fixed by switching to kcalloc() - it's more idiomatic anyway.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

applied


