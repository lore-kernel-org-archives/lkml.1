Return-Path: <linux-kernel-owner+w=401wt.eu-S1762720AbXKIMp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762720AbXKIMp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 07:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXKIMpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 07:45:50 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:56245 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580AbXKIMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 07:45:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hUWQwXAFx3X3W/VyMz4EN+r08nEncQlGWmStxyQ1MlDiT8OIZf/Q/7f3y+eHnLnWjS/DGjkYrej4XKPFCkVpMcBulAHrAH02tE6Sp++SJwbmRU83zPiNk/bML6DNXLW2FG4NWL1UUQPYzBsmG4OYeiQB53OT6sdQN3LdM6mtA+Q=
Date: Fri, 9 Nov 2007 19:45:33 +0700
From: Riki Oktarianto <rkoktarianto@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] Add quirk to set AHCI mode on ICH boards
Message-ID: <20071109124533.GA6665@ceren>
References: <20071109020235.GA2031@ceren> <20071109023129.GA25581@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109023129.GA25581@havoc.gtf.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 09:31:30PM -0500, Jeff Garzik wrote:
> On Fri, Nov 09, 2007 at 09:02:35AM +0700, Riki Oktarianto wrote:
> > Some BIOSen map AHCI ABAR but lock the SATA controller to IDE mode.
> > This patch add quirk to set AHCI mode on ICH board with such case.
> > 
> > Tested on Macbook2,1 (ICH7M)
> 
> Intel will complain but it's awful tempting...
> 
> 	Jeff
> 
> 

Then the tempted users will complain back :)

-- 
Riki Oktarianto
