Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbZCPSc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbZCPSc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZCPScb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:32:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZCPSca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:32:30 -0400
Message-ID: <49BE9B0D.8080807@kernel.org>
Date: Mon, 16 Mar 2009 11:31:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97B0.8000004@kernel.org> <49BE98FB.9050406@zytor.com>
In-Reply-To: <49BE98FB.9050406@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>
>> need more extra check for INIT_MAP_SIZE calculating...
>>
> 
> The original calculation was designed to map enough memory that we could
> map all of lowmem.  That is, two page table levels removed from actual
> lowmem, which put the overhead in the order of kilobytes (16 K in the
> wost case.)  Something similar is definitely needed.
> 
or find_early_table_space()  has some problem? that estimating could be oversized ...

YH 
