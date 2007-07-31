Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbXHAJz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbXHAJz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbXHAJzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:55:50 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:46829 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408AbXHAJzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:55:49 -0400
X-Greylist: delayed 1007 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 05:55:48 EDT
Message-ID: <46AF28CF.6000302@student.ltu.se>
Date: Tue, 31 Jul 2007 14:19:27 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Al Viro <viro@ftp.linux.org.uk>, Yoann Padioleau <padator@wanadoo.fr>,
       kernel-janitors@vger.kernel.org, rmk@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
References: <200707270944.LAA17082@ifs.emn.fr> <20070727095905.GU27237@ftp.linux.org.uk> <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 27 2007 10:59, Al Viro wrote:
>   
>> On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
>>     
>>>  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
>>> -		if (buf == 0) {
>>> +		if (buf == NULL) {
>>>       
>> 		if (!buf)
>> surely...
>>     
>
> Makes it look like it's used as a bool.
>   
But the conditional checking for a pointer and a boolean is the same; 0 
== NULL == 'false' and the rest is valid/'true'. So IMHO it is a cleaner 
way to write it. But then again, some people like to abuse the '!' on 
"regular" variables.

Richard Knutsson


