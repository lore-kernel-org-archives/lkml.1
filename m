Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbXLBO3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbXLBO3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 09:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbXLBO25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 09:28:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:58962 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbXLBO25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 09:28:57 -0500
Message-ID: <4752C1E0.7080104@qumranet.com>
Date: Sun, 02 Dec 2007 16:32:00 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: kvm-devel@lists.sourceforge.net, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure (v2)
References: <11898788932902-git-send-email-aliguori@us.ibm.com> <200712021917.28706.amit.shah@qumranet.com>
In-Reply-To: <200712021917.28706.amit.shah@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
> * Anthony Liguori wrote:
>   
>> This patch refactors the current hypercall infrastructure to better support
>> live migration and SMP.  It eliminates the hypercall page by trapping the
>> UD exception that would occur if you used the wrong hypercall instruction
>> for the underlying architecture and replacing it with the right one lazily.
>>     
>
> This doesn't work right for SVM. It keeps looping indefinitely; on a kvm_stat 
> run, I get about 230,000 light vm exits per second, with the hypercall never 
> returning to the guest.
>   

I just tested kvm.git with (the new) hypercall.flat testcase.  Seems to 
work fine.

-- 
error compiling committee.c: too many arguments to function

