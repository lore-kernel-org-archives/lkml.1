Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbZDMTD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbZDMTD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 15:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZDMTDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 15:03:20 -0400
Received: from gw.goop.org ([64.81.55.164]:45031 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbZDMTDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 15:03:19 -0400
Message-ID: <49E38C76.2090308@goop.org>
Date: Mon, 13 Apr 2009 12:03:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       Valdis.Kletnieks@vt.edu, travis@sgi.com, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, rusty@rustcorp.com.au, davej@redhat.com,
       lenb@kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>	<4609.1239456126@turing-police.cc.vt.edu>	<alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>	<20090413171853.GA4601@elte.hu>	<20090413102749.4ca3a217.akpm@linux-foundation.org>	<alpine.LFD.2.00.0904131040350.4583@localhost.localdomain> <20090413114932.44b47910.akpm@linux-foundation.org>
In-Reply-To: <20090413114932.44b47910.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>   
>> IOW, why not just do
>>
>> 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
>>
>> here?
>>
>>     
>
> Didn't know it existed :(
>   

It's relatively new compared to the rest of the smp_call_function_* family.

    J
