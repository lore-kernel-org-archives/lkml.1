Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbYHRVqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbYHRVqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbYHRVpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:45:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:62042 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbYHRVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=k4disgYnF6+4byXM18lsWYX8WhHmfGUsXp1kFT5HaZEcNo6amCP8eZOYO/87oHnyVG
         7LrK8Ysr+87fcRbjCnaZ+mdVWRWE4cTnZcGbQQRXrmJGdlKmXvLb/Dw/6avdgytcc+YD
         /odzio1dGOvA4GIZ7YdL+imHXyUWOdKBlL3w0=
Date: Tue, 19 Aug 2008 01:45:44 +0400
From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [Bug #11191] 2.6.26-git8: spinlock lockup in c1e_idle()
Message-ID: <20080819014544.390ff3c2@gmail.com>
In-Reply-To: <sNRO-BDDjQL.A.ugH.CdzpIB@albercik>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik>
	<sNRO-BDDjQL.A.ugH.CdzpIB@albercik>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of 2.6.26-rc3-git3 bug still exist.
It affect both i386 and x86_64 architectures.

Mikhail

On Sat, 16 Aug 2008 21:02:46 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11191
> Subject		: 2.6.26-git8: spinlock lockup in c1e_idle()
> Submitter	: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> Date		: 2008-07-24 03:22 (24 days old)
> References	: http://lkml.org/lkml/2008/7/23/317
> Handled-By	: Thomas Gleixner <tglx@linutronix.de>
> 
> 
