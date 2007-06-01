Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXFAV4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXFAV4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760823AbXFAV4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:56:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:3784 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760351AbXFAV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HoRSG6An2B/aGdtzpy0wCoxls44teaNz+zSD/9xIkJ53Uju/KIMHG/r0H8c1Wn6JHXoiDBMJF4d0Zz0vTZgmSKndZWi/JGTPtYGCaVkYikfPI9wrBNbCEExmNEaJE2zaRyvJIyfk1fdJQzj/n1K7QWY8ercHsxwi4J27JA6rulE=
Message-ID: <86802c440706011456x24217d36t644497e5ab57bb15@mail.gmail.com>
Date: Fri, 1 Jun 2007 14:56:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/3]i386: early init pgt for fix virtual addr in head.S
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1wsynxvlb.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705202219o21d11023od1018d253364bf5c@mail.gmail.com>
	 <m1ps4fzdq0.fsf@ebiederm.dsl.xmission.com>
	 <86802c440706011246n795ecabfke0dfd1a695ba5e5f@mail.gmail.com>
	 <m1wsynxvlb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Yes.  I posted it to lkml, and the virtualization list, on the 30th of April.
> I thought you had seen that.
>

4/30?, switch time! No computer yet.

I follow your post last year, and made it to adaptive to relocatable kernel.
for x86_64 head.S
you are using _KERNPG_TABLE + _PAGE_USER
and i found out it it is _PAGE_TABLE.===> otherwise initrd can not be loaded.

for other code for i386, you may need to dig and repost it.

for code in early_printk.c, i added some timeout control. your orginal
code will hang if client not take accept char.

two things left:
1. find port with debug device, and set it to default debug port.
Nvidia chipset has one in PCI config space. need to check other
chipset...
2. make ehci controller can work at the same time with debuge port.

YH
