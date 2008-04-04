Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYDDSNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYDDSNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbYDDSMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:12:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:52332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYDDSMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D1+kCC0aJfZdDZCsVA1XpBhcXsfBmi8UMd2apK3bT6H5Cav3FwTw/0g8ywRxNmj0KlT96invCWoGsF850BLXaXqscpAkwr08jzdQ9D2JpWz3NNvnHGLtSG07gSy+o+V+y1VtquGPRmV4UjFprsULLK/oWghKEMLv6slIg4YrYIQ=
Message-ID: <47F66F9C.2060107@googlemail.com>
Date: Fri, 04 Apr 2008 20:12:44 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>, netdev <netdev@vger.kernel.org>,
       linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: array subscript is above array bounds warnings with gcc4.3
References: <47F665E6.2010409@googlemail.com> <20080404180509.GA1900@cs181133002.pp.htv.fi>
In-Reply-To: <20080404180509.GA1900@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Fri, Apr 04, 2008 at 07:31:18PM +0200, Gabriel C wrote:
>> Hi,
>>
>> I noticed these warning on my randconfig logs of some builds :
>>
>> ..
>>
>> drivers/usb/core/hcd.c: In function 'usb_hcd_poll_rh_status':                                                                                                
>> include/asm/string_32.h:65: warning: array subscript is above array bounds
>>
>> net/netfilter/nf_conntrack_proto_sctp.c: In function 'sctp_packet':                                                                                          
>> net/netfilter/nf_conntrack_proto_sctp.c:374: warning: array subscript is above array bounds
>>
>> drivers/acpi/tables/tbfadt.c: In function 'acpi_tb_create_local_fadt':                                                                                       
>> include/asm/string_32.h:65: warning: array subscript is above array bounds
>>
>> ...
> 
> Sounds like a known and already fixed bug in gcc.
> 
> Can you confirm that they go away when you build your compiler from the 
> head of the gcc 4.3 SVN branch?
> 

I cannot do that right now but I'll build SVN 4.3 tomorrow and report back.

Gabriel

