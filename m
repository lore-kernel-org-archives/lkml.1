Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYGSHeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYGSHeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 03:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbYGSHdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 03:33:53 -0400
Received: from il.qumranet.com ([212.179.150.194]:52939 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbYGSHdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 03:33:52 -0400
Message-ID: <488198DF.4080200@qumranet.com>
Date: Sat, 19 Jul 2008 10:33:51 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: [PATCH] update kvm's anon_inodes.c for r/o bind mounts
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com>	 <1212445810.8211.9.camel@nimitz.home.sr71.net>	 <48469BDA.3050206@qumranet.com> <1212738105.7837.3.camel@nimitz>	 <48512028.3070104@qumranet.com>  <1216148242.25942.6.camel@nimitz>	 <1216244660.8711.6.camel@nimitz> <1216248527.11664.9.camel@nimitz>	 <487EDE26.8040201@qumranet.com> <1216277156.11664.21.camel@nimitz>
In-Reply-To: <1216277156.11664.21.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> That also reminds me.  kvm somehow has an outdated copy of
> anon_inodes.c.  It needs to be updated for the r/o bind mount patches to
> add a proper mnt_want/drop_write().  Otherwise, you'll run into warnings
> about imbalanced mount writer counts.  Something like this will do, but
> it would be best to just stay up to date with mainline for this kind of
> stuff.
>
>   

Instead I changed the code to use the host's anon_inodes when 
available.  I also introduced a couple of bugs but the list fixed these 
quickly.  Thanks list!

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

