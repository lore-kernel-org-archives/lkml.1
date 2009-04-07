Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbZDGD4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbZDGD4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 23:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbZDGD4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 23:56:32 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:63442 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbZDGD43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 23:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DO2Ok0+O2/eYqUPRgG9EZzwekAHYRbrq4IdA7orcj+0PWnbSh096eO9fi/TzPzZvsN
         bmOAWb5crTL1V6k+j+NaP3otbDbxB9Ma8jfO0TzZLT1gvlyIjlTi36EKk7VgYk8xH5a2
         4GqBgtKkkKn9UfAfoin2gRwYjU0BsgjW5Q3wg=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain>
Date: Mon, 6 Apr 2009 21:56:27 -0600
Message-ID: <9b1675090904062056v235af58ehc99cce8ff97fe501@mail.gmail.com>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 3:53 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13018
>> Subject               : 2.6.29 on MacBook 2,1 fails to reboot
>> Submitter     : Trenton Adams <trenton.d.adams@gmail.com>
>> Date          : 2009-03-30 2:04 (8 days old)
>> References    : http://marc.info/?l=linux-kernel&m=123837870307249&w=4
>> Handled-By    : "Morten P.D. Stevens" <mstevens@win-professional.com>
>
> This went through bisection, but looking at the email log, I tend to
> suspect that maybe Trenton marked some versions good even though they
> weren't (because they got versions numbers from v2.6.27), and didn't
> realize that that messes up bisection in a big way.

Is it appropriate for me to respond to these things?

I was wondering about that.  Someone had mentioned that I should trust
the bisect, even when it takes me into "other versions", and it was
taking me through 2.6.27, which I thought was just really weird.
Would you like me to try the bisect again with a little more
diligence, or do you think it can be found with the info given?  It
may take a week or so, due to being a bit busy.

Thanks
