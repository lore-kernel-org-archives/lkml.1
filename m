Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZBRTHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZBRTHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZBRTGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:06:51 -0500
Received: from smtp101.prem.mail.sp1.yahoo.com ([98.136.44.56]:34768 "HELO
	smtp101.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750740AbZBRTGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:06:51 -0500
X-YMail-OSG: k__VtqAVM1n3AexehTqlNzfo3DIeVmDq2lMHXzw36yaqDabAme1qlHYjyIHzIwq.5knEkwXBqOS3IWjpurc.e_49zC2AL9qEIrehDJDyzyFl.4SDwwQ_O7m6owNij8rLbpDxDIvl4RWiNSQuduPhrZuGt2NBEB.HHiJXJ8OKiaJELB0cksWaMcIuqHJqNIy75wlGN.Ldk52kYT3y1AcErX8-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <499C5C44.4020902@schaufler-ca.com>
Date: Wed, 18 Feb 2009 11:06:44 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: Paul Moore <paul.moore@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK netfilter smacklabel socket match
References: <fa.O38YY4pVfLlMFJNBI3mhgn+qOcQ@ifi.uio.no> <200902171852.21061.paul.moore@hp.com> <499BB76C.1030109@numericable.fr> <200902181005.24952.paul.moore@hp.com> <499C5377.8050408@numericable.fr>
In-Reply-To: <499C5377.8050408@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> hello,
>
> Paul Moore wrote:
> ..
>   
>> Well, since you have some time and willingness to do things "the right way" I 
>> would recommend dropping these patches (which are really just band-aids) and 
>> working on the right solution to stored the addresses/masks in a sorted list 
>> with the mask already applied.
>>
>>     
> OK, I'm about to send a new patch; but while testing my patches and reading code, I noticed another bug : 
>
> In smackfs.c:smk_write_netlbladdr
> the netmask mask.s_addr is not handled correctly, the netmask should be :
> 1- computed in u32
> 2- converted to be32 !!
> with current code, a "pseudo u32 mask" is applied to a be32 ipaddr; it occurs to works for "common netmasks" (multiple of 8), not for "intermediate" mask (/15, /25)
>   

Well, that's embarrassing. I am really looking forward to your
fixes!



