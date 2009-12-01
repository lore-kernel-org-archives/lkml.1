Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZLAW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZLAW7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 17:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZLAW7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 17:59:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43865 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLAW7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 17:59:23 -0500
Message-ID: <4B159EEA.6030503@zytor.com>
Date: Tue, 01 Dec 2009 14:55:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Joseph Parmelee <jparmele@wildbear.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: futex_cmpxchg_enabled not set in futex_init on pentium3
References: <alpine.LNX.2.00.0911291057100.2912@bruno> <4B143AE8.5090608@us.ibm.com> <alpine.LFD.2.00.0911302307440.24119@localhost.localdomain> <alpine.LNX.2.00.0912011428350.855@bruno> <alpine.LFD.2.00.0912012236120.24119@localhost.localdomain> <alpine.LNX.2.00.0912011550120.855@bruno>
In-Reply-To: <alpine.LNX.2.00.0912011550120.855@bruno>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 01:52 PM, Joseph Parmelee wrote:
> 
> On Tue, 1 Dec 2009, Thomas Gleixner wrote:
> 
>> thanks for testing. Can you please provide your 2.6.31.x .config file ?
> 
> Attached is the current 2.6.31.6 .config.
> 
> Joseph

Note: the best thing you could do -- although it is a bit time consuming
-- would be to do a "git bisect" between the last known working version
(2.6.28) and first broken version (2.6.31).

	-hpa
