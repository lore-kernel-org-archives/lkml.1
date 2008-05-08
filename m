Return-Path: <linux-kernel-owner+w=401wt.eu-S1762947AbYEHO6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762947AbYEHO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbYEHO6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:58:41 -0400
Received: from gw.goop.org ([64.81.55.164]:50386 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbYEHO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:58:40 -0400
Message-ID: <48231518.9010209@goop.org>
Date: Thu, 08 May 2008 15:58:32 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH/RFC] stop_machine: make stop_machine_run more virtualization
 friendly
References: <200805081520.38310.borntraeger@de.ibm.com> <48230137.9090705@goop.org> <200805081641.20572.borntraeger@de.ibm.com>
In-Reply-To: <200805081641.20572.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger wrote:
> I really like 64 guest cpus as a good testcase for all kind of things. 
>   

Sure, I do the same kind of thing.

>> I think x86 (at least) is now using ticket locks, which is fair.  Which 
>> kernel are you seeing this problem on?
>>     
>
> Sorry, forgot to mention. Its kvm.git from 2 days ago on s390.
>   

And on s390 cpu_relax yields the vcpu?  That's not common behaviour 
across architectures.

    J
