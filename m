Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbXBRTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbXBRTjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbXBRTjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:39:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:62525 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXBRTjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:39:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=p7J17NvKPJglBk3VE7npA9Z5FzprnMAFYwGq8c9A0IjJu74dWwNNPyF1UtqbfZkRRK0XvRn+aFbcJeu1OV9JjBaw2AEUnQsr0kKBxpPGXXQShTQJ4m5Q+07R9hmKEVU3Pf4iVo4lCGyiEFBUcIOMHFhzfWVQ4tnSRjBNRprHd0s=
Date: Sun, 18 Feb 2007 22:36:46 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218193646.GA14193@cvg>
References: <20070217212918.GA26554@localdomain> <20070218104222.GC10865@cvg> <200702181813.38814.ak@suse.de> <20070218174934.GA19558@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218174934.GA19558@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 07:49:34PM +0200, Dan Aloni wrote:
| > Making window->phys u32 seems like a cleaner fix.
| > (untested) 
| 
| With this fix it still looks somewhat broken:
| 

Actually, Dan, I even don't know to do :( May be Andi know...
I think the problem is 'cause pci_read_config_word returns 0x4
and window->phys remains on 0.

		Cyrill

