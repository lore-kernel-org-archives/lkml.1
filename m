Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbYBOSw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbYBOSw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761116AbYBOSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:52:39 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54673 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761068AbYBOSwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:52:38 -0500
Message-ID: <47B5DF74.3020801@garzik.org>
Date: Fri, 15 Feb 2008 13:52:36 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 06/11] ata: sparse fixes for pata_amd.c
References: <3ad7c41048d88a3f8aad098570b9fac9ff719aff.1202965399.git.harvey.harrison@gmail.com> <1202966060.2748.20.camel@brick>
In-Reply-To: <1202966060.2748.20.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> drop return statement.
> drivers/ata/pata_amd.c:149:2: warning: returning void-valued expression
> 
> Commit ce54d1616302117fa98513ae916bb3333e1c02ea pata_amd: update mode selection for NV PATAs
> 
> added the initializer for nv_mode_filter but missed deleting the previously
> set mode_filter
> 
> drivers/ata/pata_amd.c:509:3: warning: Initializer entry defined twice
> drivers/ata/pata_amd.c:521:3:   also defined here
> drivers/ata/pata_amd.c:544:3: warning: Initializer entry defined twice
> drivers/ata/pata_amd.c:556:3:   also defined here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/ata/pata_amd.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)

applied 6-10


