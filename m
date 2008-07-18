Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYGRJRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYGRJRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbYGRJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:17:36 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:18088 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYGRJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m1oIHyvBbQNeoTlxg1HbXDgfI7Rzjo1GuRs4tzqxX7jHOKgHJxsN3Ydyg9LdY7mGaD
         Mw3UgeBBc1rFzWEh6us5m95apSHoNwPsJD+d+VaNM1fDKH7itrMmagzWj7l5Ju9tSBTX
         iFW6QswD+GYdCWrzyk8t/4Zt8m5frXJYdoP78=
Message-ID: <b637ec0b0807180217n3b16bcb9wce81161c2c539d7f@mail.gmail.com>
Date: Fri, 18 Jul 2008 11:17:31 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "Justin Mattock" <justinmattock@gmail.com>
In-Reply-To: <c6ZRbn0adb.A.LgB.aKleIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Y1jK9GMA8kJ.A.qOH.7GleIB@albercik>
	 <c6ZRbn0adb.A.LgB.aKleIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
I also have this problem with 2.6.26 and when it happens I can notice
that sometimes gnome-power-manager is slow to respond when I switch to
AC from battery and viceversa. Also, sometimes the g-p-m icon
disappears and I have to restart the process.

I tried two days ago the patch

   http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view

and everything seems to work ok since then. Before that, the message
showed up sometimes at boot time, sometimes minutes later, very
reliably.

This is with a two years old fairly standard HP laptop.

Regards,
Fabio



On Sun, Jul 13, 2008 at 8:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10724
> Subject         : ACPI: EC: GPE storm detected, disabling EC GPE
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-05-16 6:17 (59 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
