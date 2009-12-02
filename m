Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZLBBou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZLBBou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZLBBot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:44:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZLBBos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:44:48 -0500
Message-ID: <4B15C5A8.8050708@zytor.com>
Date: Tue, 01 Dec 2009 17:40:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
References: <alpine.LNX.2.00.0911291057100.2912@bruno> <4B143AE8.5090608@us.ibm.com> <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain> <alpine.LNX.2.00.0912011428350.855@bruno> <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain> <alpine.LNX.2.00.0912011550120.855@bruno> <4B159EEA.6030503@zytor.com> <alpine.LNX.2.00.0912011757140.855@bruno>
In-Reply-To: <alpine.LNX.2.00.0912011757140.855@bruno>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 04:53 PM, Joseph Parmelee wrote:
> 
> 
> 
> On Tue, 1 Dec 2009, H. Peter Anvin wrote:
> 
>> Note: the best thing you could do -- although it is a bit time consuming
>> -- would be to do a "git bisect" between the last known working version
>> (2.6.28) and first broken version (2.6.31).
> 
> Just to clarify, the last known working version is 2.6.30.6; the first known
> bad version is 2.6.31.
> 

OK, you'd be bisecting 2.6.30..2.6.31 then.

	-hpa

