Return-Path: <linux-kernel-owner+w=401wt.eu-S1760404AbYDDSGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404AbYDDSGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760076AbYDDSFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:05:33 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52893 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771AbYDDSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:05:30 -0400
Date: Fri, 4 Apr 2008 21:05:09 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>, netdev <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: array subscript is above array bounds warnings with gcc4.3
Message-ID: <20080404180509.GA1900@cs181133002.pp.htv.fi>
References: <47F665E6.2010409@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47F665E6.2010409@googlemail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 07:31:18PM +0200, Gabriel C wrote:
> Hi,
> 
> I noticed these warning on my randconfig logs of some builds :
> 
> ..
> 
> drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':                                                                                                
> include/asm/string_32.h:65: warning: array subscript is above array bounds
> 
> net/netfilter/nf_conntrack_proto_sctp.c: In function 'sctp_packet':                                                                                          
> net/netfilter/nf_conntrack_proto_sctp.c:374: warning: array subscript is above array bounds
> 
> drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':                                                                                       
> include/asm/string_32.h:65: warning: array subscript is above array bounds
> 
> ...

Sounds like a known and already fixed bug in gcc.

Can you confirm that they go away when you build your compiler from the 
head of the gcc 4.3 SVN branch?

> Regards,
> 
> Gabriel

cu
Adrian


-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

