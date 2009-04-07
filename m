Return-Path: <linux-kernel-owner+w=401wt.eu-S1759730AbZDGCN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730AbZDGCN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbZDGCNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:13:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:4445 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZDGCNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CM5SWeJ5Jcy5KCeqDSWRc5Vpmv03fEoPbZJ4YP8H2AIl5t0MDBPLCXrzQNXGFru4zd
         B7nD54gZFWbSnGsAX81uZzpbixaexmuPmSZbRqhl05caeOc1ykXmqqNwB6Ys/kPx48XR
         Rc3Ua3hlffkzsEkHjgu0iUsbovBH/HEx250JQ=
MIME-Version: 1.0
In-Reply-To: <AsKNxFx2juN.A.0OH.0Fn2JB@chimera>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.0OH.0Fn2JB@chimera>
Date: Mon, 6 Apr 2009 20:13:44 -0600
Message-ID: <9b1675090904061913o614e02fdl22ef2cf795525a6d@mail.gmail.com>
Subject: Re: [Bug #13018] 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       mstevens@win-professional.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Yes, it is still a problem.  I have identified it as far down to being
an alsa problem.  Please follow the other thread related to this.  I
posted some more recent data, with strace info and such.  I also used
git bisect to narrow it down.  I wasn't, however, able to understand
what was happening exactly in the code.

If you need more info, or want me to try something, please just let me know.

Thanks.

On Mon, Apr 6, 2009 at 1:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13018
> Subject         : 2.6.29 on MacBook 2,1 fails to reboot
> Submitter       : Trenton Adams <trenton.d.adams@gmail.com>
> Date            : 2009-03-30 2:04 (8 days old)
> References      : http://marc.info/?l=linux-kernel&m=123837870307249&w=4
> Handled-By      : "Morten P.D. Stevens" <mstevens@win-professional.com>
>
>
>
