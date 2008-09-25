Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbYIYEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbYIYEjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYIYEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:39:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34312 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYIYEjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:39:11 -0400
Message-ID: <48DB15DB.8040501@zytor.com>
Date: Wed, 24 Sep 2008 21:38:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alok kataria <alokkataria1@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Yan Li <elliot.li.tech@gmail.com>,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, akataria@vmware.com,
       Daniel Hecht <dhecht@vmware.com>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
References: <20080221115452.GB13948@elte.hu>	 <20080907234510.GA24133@yantp.cn.ibm.com>	 <20080908140423.GG11993@elte.hu> <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
In-Reply-To: <35f686220809241928k3669e30bi8a98b440443c4bff@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok kataria wrote:
> 
> Even if there is anything on that port on native hardware it would
> work perfectly well and is _safe_.
> First let me post the code to access this backdoor port (the way it
> should really be done )
> 
> So whenever we query port  0x5658 , with the GETVERSION command (which
> is the first thing we do with this port), we expect that  eax !=
> 0xFFFFFFFF   and ebx has a  VMWARE specific MAGIC value.  Please note
> that ebx has been initialized to zero in the code above.
> 

You have no idea what you just did to a real piece of hardware.

	-hpa
