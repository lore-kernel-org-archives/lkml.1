Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZASUH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZASUH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZASUHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:07:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38378 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZASUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:07:48 -0500
Message-ID: <4974DD86.2090300@zytor.com>
Date: Mon, 19 Jan 2009 12:07:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 	to dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>	 <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com>
In-Reply-To: <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avuton Olrich wrote:
> 2009/1/19 H. Peter Anvin <hpa@zytor.com>:
>>> bisected to:
>>> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
>>> Author: Suresh Siddha <suresh.b.siddha@intel.com>
>>> Date:   Tue Jul 29 10:29:19 2008 -0700
>>>
>> Avuton, could you please compile the attached program and send us the
>> output?
> 
> Sure whichever flavor you prefer:
> http://avuton.googlepages.com/cpuid-out (3M)
> http://avuton.googlepages.com/cpuid-out.bz2 (40K)

OK, that's an XSAVE-capable CPU, and yet the XSAVE code causes a crash. 
  Not good...

	-hpa
