Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYAYDB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYAYDB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 22:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYAYDBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 22:01:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:52940 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbYAYDBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 22:01:48 -0500
Message-ID: <47995115.9090903@garzik.org>
Date: Thu, 24 Jan 2008 22:01:41 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 09/26] atl1: refactor tx processing
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>	<1199152804-3889-10-git-send-email-jacliburn@bellsouth.net>	<4795BE39.6000505@garzik.org>	<20080122183109.5ab80802@osprey.hogchain.net> <20080124190024.1b81238e@osprey.hogchain.net>
In-Reply-To: <20080124190024.1b81238e@osprey.hogchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> On Tue, 22 Jan 2008 18:31:09 -0600
> Jay Cliburn <jacliburn@bellsouth.net> wrote:
> 
>> On Tue, 22 Jan 2008 04:58:17 -0500
>> Jeff Garzik <jeff@garzik.org> wrote:
>>
> [...]
>>> for such a huge patch, this description is very tiny.  [describe]
>>> what is refactored, and why.
> 
> Is this one any better?
> 
> 
> 
>>From df475e2eea401f9dc18ca23dab538b99fb9e710c Mon Sep 17 00:00:00 2001
> From: Jay Cliburn <jacliburn@bellsouth.net>
> Date: Wed, 23 Jan 2008 21:36:36 -0600
> Subject: [PATCH] atl1: simplify tx packet descriptor
> 
> The transmit packet descriptor consists of four 32-bit words, with word 3
> upper bits overloaded depending upon the condition of its bits 3 and 4.
> The driver currently duplicates all word 2 and some word 3 register bit
> definitions unnecessarily and also uses a set of nested structures in its
> definition of the TPD without good cause. This patch adds a lengthy
> comment describing the TPD, eliminates duplicate TPD bit definitions,
> and simplifies the TPD structure itself. It also expands the TSO check
> to correctly handle custom checksum versus TSO processing using the revised
> TPD definitions. Finally, shorten some variable names in the transmit
> processing path to reduce line lengths, rename some variables to better
> describe their purpose (e.g., nseg versus m), and add a comment or two
> to better describe what the code is doing.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |  265 +++++++++++++++++++++++++----------------------
>  drivers/net/atlx/atl1.h |  201 +++++++++++++++++++-----------------
>  2 files changed, 246 insertions(+), 220 deletions(-)

Yep, better.

	Jeff



