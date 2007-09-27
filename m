Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXI0EBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXI0EBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 00:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXI0EAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 00:00:52 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64496 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbXI0EAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 00:00:51 -0400
Message-ID: <46FB2ACD.6030107@oracle.com>
Date: Wed, 26 Sep 2007 21:00:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Ram Dorai <deathtofat@gmail.com>
CC: Konrad Rzeszutek <konrad@darnok.org>, linux-kernel@vger.kernel.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com
Subject: Re: [PATCH] Add iSCSI iBFT support.
References: <20070926184652.GA16369@andromeda.dapyr.net>	 <20070926142950.46bbfcd2.randy.dunlap@oracle.com>	 <200709262052.44845.konrad@darnok.org> <14e4363b0709261817t5f0b1922m99c24549ce316de8@mail.gmail.com>
In-Reply-To: <14e4363b0709261817t5f0b1922m99c24549ce316de8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ram Dorai wrote:
> 
>     Fixed.
>      > > +static int
>      > > +ibft_mmap_binary(struct kobject *kobj, struct bin_attribute
>     *attr,
>      > > +            struct vm_area_struct *vma)
>      >
> 
> 
> 
> Do we not put a space between binary and '('. Is that against the coding 
> guidelines?

Right, we do not put a space there.

It's read_binary(ko, attr, vma);

so function names have no space following them, but
if, for, switch, and while do have space following them.

-- 
~Randy
Phaedrus says that Quality is about caring.
