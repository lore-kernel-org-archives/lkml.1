Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZAKQKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZAKQKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 11:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZAKQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 11:10:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:49828 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZAKQKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 11:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L1pHg5bhyvxBvJtgmUuFcpexZnGaX+5L/sbPcDYE+0bQslJwJVOnUhbcqnQDLyzug3
         FobORskNxpdOrz96sRGr+pWox1fMISw/Ah8mcIab44lmBkP9P4Xrqpx6YdaiIMacWxuA
         peAaAPFkJ/r42BD/V4awPYRiHOLzPyLcYo6tE=
Message-ID: <b6a2187b0901110810u452b05b8t2d1da38db36113a@mail.gmail.com>
Date: Mon, 12 Jan 2009 00:10:23 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <4969FD64.8040408@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <oWTznAnH9BI.A.qDH.EHfaJB@chimera> <4969FD64.8040408@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 10:08 PM, Daniel Drake <dsd@gentoo.org> wrote:
> Rafael J. Wysocki wrote:
>>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.28.  Please verify if it still should be listed and let me know
>> (either way).
>>
>>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
>> Subject         : 2.6.28-git can't resume from str
>> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
>> Date            : 2009-01-10 1:39 (2 days old)
>> References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4
>
> The bisection looks invalid. It is unlikely to be this commit at fault.

I have doubt about this too, but it's was git bisect zero into. All I
know is a0e280e0f33f6c859a235fb69a875ed8f3420388 is definitely good.

> Jeff, do you even have that camera?

No, I don't have this.


> It is also easy to revert that commit by hand. Just delete the unusual_devs
> entry for it.

I'm lost reverting this. Right now, I'm just use "git diff" and throw
away everything after a0e280e0f33f6c859a235fb69a875ed8f3420388, and my
system can STD, STR without an problem resuming.

Thanks,
Jeff.
