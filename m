Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZKFLde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZKFLde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZKFLdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:33:33 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57241 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZKFLdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:33:33 -0500
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<1257468114-6823-1-git-send-email-ebiederm@xmission.com>
	<200911061004.01007.borntraeger@de.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 03:33:31 -0800
In-Reply-To: <200911061004.01007.borntraeger@de.ibm.com> (Christian Borntraeger's message of "Fri\, 6 Nov 2009 10\:04\:00 +0100")
Message-ID: <m18wejanw4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Am Freitag 06 November 2009 01:41:44 schrieb Eric W. Biederman:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> In preparation for more invasive cleanups separate the core
>> binary sysctl logic into it's own file.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Hmm, with your patches on Linus git I get the following on s390:
>
> kernel/sysctl_binary.c: In function 'SYSC_sysctl':
> kernel/sysctl_binary.c:126: error: implicit declaration of function 
> 'lock_kernel'
> kernel/sysctl_binary.c:129: error: implicit declaration of function 
> 'unlock_kernel'

Bah.  A missing smp_lock.h.


Thanks.
Eric

