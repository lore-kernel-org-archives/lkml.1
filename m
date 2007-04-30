Return-Path: <linux-kernel-owner+w=401wt.eu-S1423229AbXD3NFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423229AbXD3NFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423233AbXD3NFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:05:43 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:51184 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423229AbXD3NFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:05:34 -0400
Message-ID: <4635E99D.5010004@hp.com>
Date: Mon, 30 Apr 2007 09:05:33 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way
 IA64
References: <4635D59C.4050300@hp.com> <20070430122753.GL21015@kernel.dk>
In-Reply-To: <20070430122753.GL21015@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Apr 30 2007, Alan D. Brunelle wrote:
>   
>> The results from a single run of an AIM7 DBase load on a 16-way ia64 box 
>> (64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by adding 
>> in this patch. (Graph can be found at   
>> http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a single 
>> set of runs, on a single platform, but it is something to keep an eye on 
>> as the regression showed itself across the complete run.
>>     
>
> Do you know if this regression is due to worse IO performance, or
> increased system CPU usage?
>
>   
Unfortunately, the runs generate different X points - I'm going to try 
and get a second run with the same X-points, and then I can compare 
iostat results (these are being collected).

I do have some iostat data from these runs, and I am trying to make 
sense of them. But, with only about a 0.5% difference in performance, 
and different X values, not much can be gleaned. We'll see when the 
second run of a kernel can be done, and I'll get back to you on that.

Alan
