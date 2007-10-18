Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXJRNub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXJRNub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762814AbXJRNt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:49:57 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57223 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762582AbXJRNt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:49:56 -0400
Message-ID: <47176459.1030302@bull.net>
Date: Thu, 18 Oct 2007 15:49:13 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: IceDove 1.5.0.12 (X11/20070606)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, borntraeger@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH] move kvm_guest_exit() after	local_irq_enable()
References: <47135D1B.1060004@bull.net>	<11927135412363-git-send-email-Laurent.Vivier@bull.net> <4717607A.8070304@qumranet.com>
In-Reply-To: <4717607A.8070304@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 15:56:21,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 18/10/2007 15:56:25,
	Serialize complete at 18/10/2007 15:56:25
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity a écrit :
> Laurent Vivier wrote:
>> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if we move
>> it after local_irq_enable().
>>
>> http://lkml.org/lkml/2007/10/15/114
>>
>> To simplify s390 port, we don't clear it in account_system_time().
>>
>> http://lkml.org/lkml/2007/10/15/183
>>   
> 
> Applied (the kvm part), and added a fat comment on the barrier.  Can you 
> send a signed-off-by: line?
> 

Sorry, I missed it...

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>

