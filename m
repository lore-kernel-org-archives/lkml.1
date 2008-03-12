Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYCLWoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYCLWoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCLWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:44:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:61214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYCLWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:44:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Rv/WJTQGFJhd1zPGEzfsNaDC9cGuPFs6lOWlj71yfIwBjVsf1Fd2Y/HK+RuJ4AkQB7u4eKAxIw4tOKy1Hpbn97Qfl6mejgKDkIOTLTTAl7RNBNj1SyIz4uoPshxv4xgbpQj0g35Tnu9JKe/92KfoC4rRWpOLBv1zZPo4pUUxh9M=
Message-ID: <47D85CAC.90402@gmail.com>
Date: Wed, 12 Mar 2008 23:43:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: /proc/loadavg: total number of processes is wrong?
References: <47D85916.5080203@redhat.com>
In-Reply-To: <47D85916.5080203@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2008 11:28 PM, Chuck Ebbert wrote:
> # cat /proc/loadavg ; ps ax | wc -l
> 0.00 0.00 0.00 1/192 3683
> 121
> 
> /proc/loadavg says 192 processes, but ps only sees 121.

I guess you need to ps max, but it won't match exactly anyway.

regards,
-- 
Jiri Slaby
Faculty of Informatics, Masaryk University
Suse Labs
