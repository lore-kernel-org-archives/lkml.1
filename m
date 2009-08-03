Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZHCScy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZHCScy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbZHCScw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:32:52 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38696 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbZHCScv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IzPkJsm1+iStclMr1vzEk+HqLAzVSqXyXIJkSvwsxJPf/9HHUuCxsk9ARsUKiqhYve
         jjD1Ueo1MBrRVMKKdhP//OnCfX2KVGqinp3+F4uObexiYhEHnsVhHOSSOA6qLsy0f90d
         HynhSqc08hrHohEHzvyqk13XFjh+538ZEBgVk=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13846] Possible regression in rt61pci driver
Date: Mon, 3 Aug 2009 19:31:27 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <Su1q3S6JjyO.A.jeB.hcgdKB@chimera> <iZB3Pj-uj3M.A.pRC.1cgdKB@chimera>
In-Reply-To: <iZB3Pj-uj3M.A.pRC.1cgdKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908031931.27427.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sunday 02 August 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>

The folks on the wireless project have concluded that the problem I reported is down to a hardware 
problem when power saving is switched on on for my Belkin cardbus wireless adapter, so now I simply 
turn power-saving off when wlan0 comes up. I did, however, ask whether anyone was going to fix the 
fact that once power-saving turns the LEDs off, they never come back on again, but I haven't had an 
answer. Is that a regression? I guess the answer is no, because power saving in the rt61pci driver 
is feature that is new to 2.6.31. Should it be fixed? I think the answer is yes, but being unable 
to do it myself, I probably don't have a vote :-)

All I can do is report that I now know how to avoid my laptop freezing and leave the decision as to 
whether it should stay on the regression list to you and the folks from the wireless project.

Thanks,

Chris

>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13846
> Subject		: Possible regression in rt61pci driver
> Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2009-07-13 8:27 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=124747418828398&w=4


-- 
No, Sir; there is nothing which has yet been contrived by man, by which so much happiness is 
produced as by a good tavern or inn - Doctor Samuel Johnson
