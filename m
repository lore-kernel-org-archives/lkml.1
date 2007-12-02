Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbXLBWUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbXLBWUp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 17:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXLBWUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 17:20:37 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:59036 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXLBWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 17:20:36 -0500
Message-ID: <47532C78.3090701@student.ltu.se>
Date: Sun, 02 Dec 2007 23:06:48 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: v4l-dvb-maintainer@linuxtv.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] [PATCH 1/2] ivtv: Some general fixes
References: <20071202173329.15374.4223.sendpatchset@thinktank.campus.ltu.se> <200712022049.33601.hverkuil@xs4all.nl>
In-Reply-To: <200712022049.33601.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil wrote:
> On Sunday 02 December 2007 18:46, Richard Knutsson wrote:
>   
>> Fix "warning: Using plain integer as NULL pointer".
>>     
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>
>   
>> Remove a gcc-2.95 requirement.
>>     
>
> NACK! The main v4l-dvb repository that contains this driver can also be 
> compiled on older systems. I'd like to keep the option that the driver 
> can be compiled with an older gcc version, unless Mauro thinks 
> otherwise. Other than the removal of one comment and one space there 
> are no other benefits of this change, so I'd prefer to keep it.
>
>   
Oh alright, thought it was just a leftover since the support for the 
2.95 ended.
Maybe add something to the text to let others know the status? (Since I 
found it by doing a 'grep' for "gcc 2.95"'s...)
>> Convert 'x < y ? x : y' to use min() instead.
>>     
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> Thanks,
>
> 	Hans
>
>   
Thanks for the fast turnaround
Richard

