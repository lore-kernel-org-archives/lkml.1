Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYFVVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYFVVMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYFVVME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:12:04 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:10233 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbYFVVMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ozBsxcPEjUunhqx4N1n2Kjx4AvKx8IECrqVe0mHx8ubHVjrpMhOkaApkY3lyfZe9IR
         zC0w90bPlLM6TzPwC6nisCfS+O6FGLGXwaFDzHirHnrh87yqBUXkEM0GtAFJQOyJ2G4b
         tOIqL0AXa0LX29XJ1tgVWGobHAyY/UdIjWV7I=
Message-ID: <dd18b0c30806221412n53922cadt70a1993ccc0d5973@mail.gmail.com>
Date: Sun, 22 Jun 2008 21:12:00 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <4mRZUF-hVeG.A.WYG.5vpXIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	 <4mRZUF-hVeG.A.WYG.5vpXIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 5:54 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> Date            : 2008-05-16 6:17 (38 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>
>
>

Yes; setting  if (atomic_read(&ec->irq_count) > 5) { to
	if (atomic_read(&ec->irq_count) > 20) {
in drivers/acpi/ac.c only prolongs the bug, after a period of time(3
to 5 hrs) the the message does appear.
regards;

-- 
Justin P. Mattock
