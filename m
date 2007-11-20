Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbXKTKVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbXKTKVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXKTKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:21:27 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46377 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbXKTKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:21:26 -0500
Message-ID: <4742B403.6060802@keyaccess.nl>
Date: Tue, 20 Nov 2007 11:16:35 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PNP cleanups - Make use of	pnp_{port,mem,irq,dma}_{start,end,flags}
 macros wherever possible
References: <1195552273.23700.164.camel@queen.suse.de>
In-Reply-To: <1195552273.23700.164.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-11-07 10:51, Thomas Renninger wrote:

> Make use of pnp_{port,mem,irq,dma}_{start,end,flags} macros wherever possible
> 
> The macros to access the resource table in pnp sublayer was not used
> consequently.
> This patch makes use of these macros instead of accessing the resource
> arrays directly.
> 
> For dma and irq also pnp_{dma,irq}_{start,end} macros have been introduced
> to unify the access to the different resource types.
> 
> The pnp_{irq,dma} macros has now the same functionality than the:
> pnp_{irq,dma}_start macros. This will be cleaned up by the next patch.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>

Earlier comments (in private mail):

>> -                dev->res.port_resource[nport].start =
>> +                pnp_port_start(dev, nport) =
>>                      simple_strtoul(buf, &buf, 0);
>> If I'm not mistaken, there's a standing fatwa on macros as lvalues.
>> Andrew?
> 
> Andrew Morton wrote: 
> 
> Well, it's a pretty nasty thing to do, IMO.  But given that we've already
> gone and done it I suppose the change is OK from a consistency POV.

Otherwise acked as identity transformation.

Acked-by: Rene Herman <rene.herman@gmail.com>

Rene.

