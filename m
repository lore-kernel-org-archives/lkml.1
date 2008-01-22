Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbYAVB7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbYAVB7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 20:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYAVB73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 20:59:29 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:7645 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYAVB72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 20:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qtTSd6Ot3ql49ZPc3iei+mlue2A2OYpj+g3cyViiYxVSp61fYY/TL/P8FU1zulNWt5onSHFFzXylRhabGY5v+huyXZyJZQqcwFGkzS+9X2HVhfZnGZD7i5WIaL3Znsqda2NSxBAyhQL1CLemnXfNYgmv9gCfJ+Nj9POn5AJIOyg=
Message-ID: <bcadbdf50801211759j5e55ba88n26c24b2f12afaf26@mail.gmail.com>
Date: Tue, 22 Jan 2008 02:59:26 +0100
From: "dAniel hAhler" <dhahler@googlemail.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: Regression with idle cpu cycle handling in 2.6.24 (compared to 2.6.22)
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080121171834.GA31049@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com>
	 <bcadbdf50801190652s75f36b1ai422d8b12c5e8ff95@mail.gmail.com>
	 <20080120033337.GA8277@linux.vnet.ibm.com>
	 <20080121171834.GA31049@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 21, 2008 6:18 PM, Srivatsa Vaddagiri wrote:
> On Sun, Jan 20, 2008 at 09:03:38AM +0530, Dhaval Giani wrote:
> > > btw: writing 1 into "cpu_share" totally locks up the computer!
> > >
> >
> > Can you please provide some more details. Can you go into another
> > console (try ctrl-alt-f1) and try to reproduce the issue there. Could
> > you take a photo of the oops/panic and upload it somewhere so that we
> > can see it?
>
> I couldn't recreate this problem either on 2.6.24-rc8.
>
> Daniel,
>         Could you pass the config file you used pls?

Sure, I've uploaded the config to
http://codeprobe.de/tmp/config-2.6.24-4-generic

It only happens when changing the cpu_share for another user and this
user needs to have a cpu hogging process running (like boinc, a
while-1 loop or similar).
It does not dump anything to the console, but the VirtualBox process
on the host takes all CPU - there seems to be no crash, but an endless
loop only.

I have reported it at http://bugzilla.kernel.org/show_bug.cgi?id=9779
already, with a testcase (outlined above).

Thank you for your help.

-- 
http://daniel.hahler.de/
