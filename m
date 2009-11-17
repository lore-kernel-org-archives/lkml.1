Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbZKQIkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbZKQIkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZKQIkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:40:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63761 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZKQIkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YDWXJ6iYLJYrgCX8IaeC+c9Xi942vEkuL2tWrOfQVK6mLaTuW+dq27+Kpp47eCNqOr
         c/h7rFpuVGdfXyIAecqBVkzX7UxA2NsrOTiyOegvgGPl99ZJ356c0aGi/SWq3t22twF8
         p+8US+0a42oL1VEmWWLuR7btNdOaSEfNK9cQ8=
MIME-Version: 1.0
In-Reply-To: <xXQGFmujPl.A.nXG.-SdALB@chimera>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.nXG.-SdALB@chimera>
Date: Tue, 17 Nov 2009 17:40:25 +0900
Message-ID: <28c262360911170040r4313ca2bs9716b9271946f082@mail.gmail.com>
Subject: Re: [Bug #14618] OOM killer, page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Norbert Preining <preining@logic.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we can ignore this bug.
We can see the mm_fault_error in stack trace.
I guess it's from returning VM_FAULT_OOM of any driver.

As I know, It happens very rarely. Norbert, right?

In addition, I don't see the any similar report.

So I think It would be better to ignore this bug
until we can meet similar report again.


On Tue, Nov 17, 2009 at 7:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14618
> Subject         : OOM killer, page fault
> Submitter       : Norbert Preining <preining@logic.at>
> Date            : 2009-10-30 6:32 (18 days old)
> References      : http://marc.info/?l=linux-kernel&m=125688434909582&w=4
> Handled-By      : Minchan Kim <minchan.kim@gmail.com>
>
>
>



-- 
Kind regards,
Minchan Kim
