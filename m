Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbZCYCvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbZCYCvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZCYCvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:51:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52094 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZCYCvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:51:32 -0400
Message-ID: <49C99C2F.9010703@garzik.org>
Date: Tue, 24 Mar 2009 22:51:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/4] libata: Improve timeout handling
References: <20090324101952.9152.30261.stgit@localhost.localdomain> <20090324102324.9152.78865.stgit@localhost.localdomain>
In-Reply-To: <20090324102324.9152.78865.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From: Alan Cox <alan@redhat.com>
> 
> On a timeout call a device specific handler early in the recovery so that
> we can complete and process successful commands which timed out due to IRQ
> loss or the like rather more elegantly.
> 
> [Revised to exclude the timeout handling on a few devices that inherit from
>  SFF but are not SFF enough to use the default timeout handler]
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

applied

let's see what explodes!  :)


