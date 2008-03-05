Return-Path: <linux-kernel-owner+w=401wt.eu-S934091AbYCEMtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091AbYCEMtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761664AbYCEMtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:49:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:60133 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761049AbYCEMtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:49:05 -0500
Message-ID: <47CE96BF.50108@garzik.org>
Date: Wed, 05 Mar 2008 07:49:03 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org, crane.cai@amd.com, Henry.Su@amd.com,
       shane.huang@amd.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] ahci: fix SB600 h/w errata issue
References: <20080228204348.GA30539@havoc.gtf.org>
In-Reply-To: <20080228204348.GA30539@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> I haven't seen anyone work on the recent SB600 errata, where the
> hardware does not like 256-length PRD entries.
> 
> Is this correct, AMD folks?
> 
> It hurts performance on SB600, but it is more important to get a
> correct patch eliminating the data corruption/lockups, and then later
> on tune for performance.
> 
> We simply limit each command to a maximum of 255 sectors, on SB600.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/ata/ahci.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

Based on Henry's response, I'm going to assume AMD approves of this patch...


