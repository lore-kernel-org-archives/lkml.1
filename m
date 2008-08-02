Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYHBDcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYHBDcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYHBDce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:32:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55006 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbYHBDce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:32:34 -0400
Message-ID: <4893D459.4030209@zytor.com>
Date: Fri, 01 Aug 2008 20:28:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	<m1iqukwjjg.fsf@frodo.ebiederm.org>	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	<m1wsj0nyx6.fsf@frodo.ebiederm.org>	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>	<m163qkjirc.fsf@frodo.ebiederm.org>	<86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>	<4893C066.60401@zytor.com> <m1abfwi1ht.fsf@frodo.ebiederm.org>
In-Reply-To: <m1abfwi1ht.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Having a human readable name like: eth0irq22 or hbairq5 is likely just
> as good in the case of msi.  Still all of the users interfaces today take numbers.
> So we are stuck with dealing with numbers for a long time to come.
> 

Long sparse numbers are messy, too, though.  It might be interesting to 
have a routine somewhere like "irq_name()" to output a human-readable 
IRQ name, which in case of MSI-X could contain the PCI device name.

	-hpa
