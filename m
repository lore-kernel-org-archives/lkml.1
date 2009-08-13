Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZHMTBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZHMTBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZHMTBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:01:51 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:21315 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZHMTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:01:50 -0400
Message-ID: <4A846342.8070200@oracle.com>
Date: Thu, 13 Aug 2009 12:02:26 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: about CONFIG_CMDLINE
References: <241b8f7b0908112320u44519e7fnfbc4fa96667cdb20@mail.gmail.com>
In-Reply-To: <241b8f7b0908112320u44519e7fnfbc4fa96667cdb20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt012.oracle.com [141.146.116.21]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A84631B.0089:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prabhu Chawandi wrote:
> Hi,
> 
>   In kernel_hardening activity, I am setting CONFIG_CMDLINE, to
> 
> CONFIG_CMDLINE is nit set.
> 
> But while building, it is prompting to select its state(y/n).
> 
> I want to disable this prompting, how can I do it ?
> 
> Any idea, please share ...

Proably posting your troublesome .config file would help,
along with your kernel version info... but I can see that
CONFIG_CMDLINE depends on CONFIG_CMDLINE_BOOL.
Do you also unset CONFIG_CMDLINE_BOOL ?

~Randy

