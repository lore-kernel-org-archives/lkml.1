Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYFEKvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYFEKvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 06:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYFEKvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 06:51:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYFEKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 06:51:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=iWz20CnB8RwY7wUKP9VpjERI3TNlu6f0a7siuISNrC/ljTzAuvzJjjdv31kel3q7/X
         4f2DlAnZJUqpTC6bj+kI6AIWwRpaSl8WQFo1sAW54S4LjYJC7hhgTMinGMs4nk9LWFGH
         Qp2+WjToF7VOO+H/NgCCAHC1Zu0kP5UBcJuZw=
Message-ID: <2f11576a0806050351o60dc1351q35f74d4e9836e20d@mail.gmail.com>
Date: Thu, 5 Jun 2008 19:51:35 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for prevent fork bomb by cgroup)
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>, "Paul Menage" <menage@google.com>
In-Reply-To: <20080605092745.GA3734@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080605092745.GA3734@linux.vnet.ibm.com>
X-Google-Sender-Auth: ba7c65181590d81e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thank you for careful review.

>> +     struct task_cgroup *taskcg;
>> +
>> +     if ((max_tasks > INT_MAX) ||
>> +         (max_tasks < INT_MIN))
>
> It should be < -1 I think.

OK.
I'll fix it at next post.



>> +     spin_lock(&taskcg->lock);
>> +     if (max_tasks < taskcg->nr_tasks)
>> +             return -EBUSY;
>
> Shouldn't you drop the lock here?

you are right.
Thanks.


> How does this controller affect performance? Do you have some numbers?

No.
but I have plan to mesure it at nearly future.
Thanks.
