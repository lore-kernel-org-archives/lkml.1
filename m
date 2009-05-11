Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbZEKWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbZEKWyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbZEKWyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:54:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbZEKWyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:54:35 -0400
Message-ID: <4A08AAE0.6030300@zytor.com>
Date: Mon, 11 May 2009 15:46:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Marc Dionne <marc.c.dionne@gmail.com>, Eric Paris <eparis@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for singleandmultiple-instancemounts
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com> <20090507232110.GB27609@linux.vnet.ibm.com> <4A04F5D7.2050909@gmail.com> <20090511221502.GA32530@linux.vnet.ibm.com> <20090511223718.GA18528@us.ibm.com>
In-Reply-To: <20090511223718.GA18528@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> ...
> 
>> >From 2f7746f4df78ff57125c4714f0cd64e739ccf804 Mon Sep 17 00:00:00 2001
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> Date: Mon, 11 May 2009 13:11:11 -0700
>> Subject: [PATCH] devpts: Correctly set default options
>>
>> devpts_get_sb() calls memset(0) to clear mount options and calls
>> parse_mount_options() if user specified any mount options. The memset(0) is
>> bogus since the 'mode' and 'ptmxmode' options are non-zero by default.
>> parse_mount_options() restores options to default anyway and can properly deal
>> with NULL mount options.
>>
>> So in devpts_get_sb() remove memset(0) and call parse_mount_options() even for
>> NULL mount options.
>>
>> Bug reported by Eric Paris: http://lkml.org/lkml/2009/5/7/448.
> 
> Would you almost say... Reported-by: ?  :)
>> Signed-off-by: Sukadev Bhattiprolu (sukadev@us.ibm.com)
> 
> Looks good.
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 

Reviewed-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
