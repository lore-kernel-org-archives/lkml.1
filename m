Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635Ab0AUDCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab0AUDCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832Ab0AUDCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:02:32 -0500
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:45520 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696Ab0AUDCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:02:31 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: Agdtw0AVM1kxAwj.PX2l4V6fPh7BhdXHjWzHzdKdRXAt3h70v7BpfOiTQWLehRq1lKmfvRkFe4QV8Oj.8wORYQFXi.DMOvs0seV.mmJtHw7OkbqXGTnewiVcwyfs4oy.nCvKx8qE_0Bq_N7C7cYhs9GcioMfo18Up2mSDWzSEskwu4uLglJJQfNl0hZAvYgJRMYmeDK8eZaX8zjdrC22PWP4vO_LfXVd7b2qfG9a9KwHuZ6X7YcZdRalFq2SmVjfFawlDqvtomZPtZxdIjJsCDdG6n298UhIzWH7C_fFktXco1HJbG7KpioAwCHQ91MFHWq8jwdeNL9mubnkiRRv2jqSVaG9QGcB1ZvYu9ByZUDhY5bSgbnQhvGA4mO_GeFoErfc.rlFrQsjFA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B57C3C3.9010606@schaufler-ca.com>
Date: Wed, 20 Jan 2010 19:02:27 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: zhou peng <ailvpeng25@gmail.com>
CC: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: About ACL for IPC Object
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com> <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>
In-Reply-To: <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zhou peng wrote:
> Hi all,
>
> There are ACL in file system, but why there are no ACL implementation
> in IPC object, eg. shm, message queue, FIFO?
>   

Most people haven't noticed that IPC objects are even there, much less
that they have mode bits and not ACLs. Even when we were doing security
evaluations on Unix boxes in the 1990's they were considered insufficiently
interesting to justify the additional work to do ACLs.

If you really want ACLs on IPC objects it would make a dandy little
project for a summer. I would be happy to review patches.

> Is there any fine grained granting in ipc object just like in file object?
>   

As Stephen Smalley points out, you can do it with SELinux, although
that it rather like driving a thumbtack with a bulldozer.

> Thanks,
> Best
>
> --
> zhoupeng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   

