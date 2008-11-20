Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYKTQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYKTQ21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:28:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYKTQ2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:28:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:48308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbYKTQ2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:28:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=GBQj6xycUT/8j5NnRyz7cyBxjBLxN76MmWe79NalS33bkstZ1XW6BiTLB+04UKL+5k
         bXyCdEB75Q5L/n3/LD16sHzzR2fl4ciUjMOBwIEryqNGksZpHMGVtUUlXsNQvnctKiSz
         d2xYjKuMJVwkokQoN/YW1hI3eqRgdZiPikguY=
Message-ID: <cfd18e0f0811200828x5c1752dcmef1cd6d52bdc08ce@mail.gmail.com>
Date: Thu, 20 Nov 2008 11:28:14 -0500
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Reply-To: mtk.manpages@gmail.com
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: CLONE_NEWIPC documentation
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Kirill Korotaev" <dev@openvz.org>,
       "Pavel Emelianov" <xemul@openvz.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
In-Reply-To: <4925575D.8060704@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4924651C.4080909@gmail.com> <m163mji4cz.fsf@frodo.ebiederm.org>
	 <49252174.7080709@fr.ibm.com>
	 <cfd18e0f0811200328g643c1bdq46a48bac3a1ea744@mail.gmail.com>
	 <4925575D.8060704@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 7:26 AM, Cedric Le Goater <clg@fr.ibm.com> wrote:
> Michael Kerrisk wrote:
>> Cedric,
>>
>> On Thu, Nov 20, 2008 at 3:36 AM, Cedric Le Goater <clg@fr.ibm.com> wrote:
>>> Eric W. Biederman wrote:
>>>> Michael Kerrisk <mtk.manpages@googlemail.com> writes:
>>>>
>>>>> Kirill, Pavel,
>>>>>
>>>>> Below is a patch to document the CLONE_NEWIPC flag that was
>>>>> added in 2.6.19.
>>>>>
>>>>> Could you please review and let me know of improvements
>>>>> or inaccuracies?
>>> I would also add that an interesting effect of the sysvipc namespace is
>>> the automatic cleanup of sysvipc objects when the namespace is destroyed.
>>
>> And the namespace is destroyed, when the last proces in the namespace
>> terminates, right?
>
> exactly.

Thanks Cedric.  I've added that point to the documentation.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
