Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZKFKTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZKFKTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 05:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZKFKTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 05:19:53 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45446 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbZKFKTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 05:19:52 -0500
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, Carsten Otte <cotte@de.ibm.com>
Subject: Re: [PATCH 07/11] sysctl: s390 Use the compat_sys_sysctl
References: <m1tyx8trik.fsf@fess.ebiederm.org>
	<1257468114-6823-7-git-send-email-ebiederm@xmission.com>
	<200911061012.17239.borntraeger@de.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 06 Nov 2009 02:19:51 -0800
In-Reply-To: <200911061012.17239.borntraeger@de.ibm.com> (Christian Borntraeger's message of "Fri\, 6 Nov 2009 10\:12\:17 +0100")
Message-ID: <m13a4srm48.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

> Am Freitag 06 November 2009 01:41:50 schrieb Eric W. Biederman:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Now that we have a generic 32bit compatibility implementation
>> there is no need for s390 to implement it's own.
>> 
>> Cc: Carsten Otte <cotte@de.ibm.com>
>> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
>
> You should have CCed Martin & Heiko, since this is cleary not KVM.
> I took a look anyway ;-)

Groan. I got the wrong s390 line in MAINTAINERS.

>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Patch looks good.
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
