Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYKTLvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYKTLvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYKTLv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:51:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:26568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYKTLv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GESPkmq4JExyRZN7ilMBmT0ertyp9+cxe+9VTmEsOwZtJALXcTEP0h+raNJopIkeM0
         x7eB7C6HEi671BzHkm0oj70Y3xVnOVRALiY4mAMYjvnHNPJWYUKn9vofZtm3dZXWWZiK
         IOpdv4StrIzOkanQlaeNGUX/JtFtiCXbA9Og8=
Message-ID: <cfd18e0f0811200351o7cf40438j195fbac14854f79a@mail.gmail.com>
Date: Thu, 20 Nov 2008 06:51:26 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: CLONE_NEWUTS documentation
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org, "Kirill Korotaev" <dev@openvz.org>,
       "Herbert Poetzl" <herbert@13thfloor.at>, "Andrey Savochkin" <saw@sw.ru>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>
In-Reply-To: <m1y6zfgpjf.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492464F8.8070101@gmail.com> <m1y6zfgpjf.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Wed, Nov 19, 2008 at 8:21 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Michael Kerrisk <mtk.manpages@googlemail.com> writes:
>
>> Serge, Eric,
>>
>> Below is a patch to document the CLONE_NEWUTS flag that was
>> added in 2.6.19.
>>
>> Could you please review and let me know of improvements
>> or inaccuracies?
>>
>> By the way, does anyone know where the UTS name in the uname()
>> API comes from? My best guess is that it's from Unix Timesharing
>> System, but I don't know this for sure.
>>
>> Cheers,
>>
>> Michael
>>
>> diff --git a/man2/clone.2 b/man2/clone.2
>> index 7212332..80f9caf 100644
>> --- a/man2/clone.2
>> +++ b/man2/clone.2
>> @@ -341,6 +340,33 @@ configuration option and that the process be privileged
>>  This flag can't be specified in conjunction with
>>  .BR CLONE_THREAD .
>>  .TP
>> +.BR CLONE_NEWUTS " (since Linux 2.6.19)"
>> +If
>> +.B CLONE_NEWUTS
>> +is set, then create the process in a new UTS namespace.
>> +If this flag is not set, then (as with
>> +.BR fork (2)),
>> +the process is created in the same UTS namespace as
>> +the calling process.
>
>> +This flag is intended for the implementation of control groups.
>
> See my previous email about containers vs control groups.

Otherwise, the documentation patch is okay?

> There are some corner cases with NFS usage in the kernel that still
> need to be resolved but otherwise the uts namespace is considered correct
> and complete.

Thanks for the info.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
