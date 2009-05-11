Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbZEKWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbZEKWVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbZEKWVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:21:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbZEKWVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:21:00 -0400
Message-ID: <4A08A472.20809@zytor.com>
Date: Mon, 11 May 2009 15:19:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>, Eric Paris <eparis@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       serue@us.ibm.com, sukadev@us.ibm.com, linux-kernel@vger.kernel.org,
       jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single	andmultiple-instancemounts
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com> <20090507231844.GA27609@linux.vnet.ibm.com> <20090507232110.GB27609@linux.vnet.ibm.com> <4A04F5D7.2050909@gmail.com> <20090511221502.GA32530@linux.vnet.ibm.com>
In-Reply-To: <20090511221502.GA32530@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
> 
> I tested this patch by directly calling the system call mount() with a NULL
> data parameter. If you/Eric/Peter can confirm that this works for you, I will
> send this patch to Andrew.
> 

Makes a lot more sense to me.  In particular, NULL should be handled the 
same as "".

	-hpa
