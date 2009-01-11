Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZAKQNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZAKQNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZAKQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:13:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:57723 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZAKQNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:13:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RJnCM2mZ/T4urocY7WexqZbvSySftJU2c0nAgdSrJpDCAbvIghaYuMeqqjrN4rH6EP
         aUIjiTHwIZ7wek3AFh+uhaAf+cseDByiR/xRIOAH5+6bXOYiHnEu/eehLuP5MSeklJs+
         UHKa5ohs+Wq0NDO+JGUyRP7yShKLRy65WjHIM=
Message-ID: <b6a2187b0901110813s5429573cm7d78f39e288f70a3@mail.gmail.com>
Date: Mon, 12 Jan 2009 00:13:32 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Daniel Drake" <dsd@gentoo.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <200901111518.38880.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <oWTznAnH9BI.A.qDH.EHfaJB@chimera> <4969FD64.8040408@gentoo.org>
	 <200901111518.38880.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 10:18 PM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> Am Sonntag 11 Januar 2009 schrieb Daniel Drake:
>> Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.28.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=12422
>> > Subject             : 2.6.28-git can't resume from str
>> > Submitter   : Jeff Chua <jeff.chua.linux@gmail.com>
>> > Date                : 2009-01-10 1:39 (2 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
>>
>> The bisection looks invalid. It is unlikely to be this commit at fault.
>> Jeff, do you even have that camera?
>>
>> It is also easy to revert that commit by hand. Just delete the
>> unusual_devs entry for it.
>
> I found a nearby commit during bisect, which looks much saner:
>
> http://marc.info/?l=linux-kernel&m=123167815028388&w=2

This was committed earlier than
a0e280e0f33f6c859a235fb69a875ed8f3420388, and
a0e280e0f33f6c859a235fb69a875ed8f3420388 was the last working kernel
that is able to suspend/resume. Go one before, and suspend/resume
breaks.

Thanks,
Jeff.
