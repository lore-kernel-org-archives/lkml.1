Return-Path: <linux-kernel-owner+w=401wt.eu-S1762579AbYGFRxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762579AbYGFRxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761362AbYGFRo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:44:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:10440 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761357AbYGFRo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lhs9S7wsim8dWfOS3HzMP+6bwHdlj8cpoVq1Pa52GxqarwjfIy+67AEQqHiFH8khdP
         o83ddKsxo/rvULXtUV1V0xI6fUpHjDwQ3Ivdayp+BzC42ZlO5l8oBOf5/OfYC7In2dw+
         /1kTD6FSHTGP1WWv9JT3beZCs9Cw5MwpL1XNw=
Message-ID: <dd18b0c30807061044w227ebce0if79cf4ea7b35b942@mail.gmail.com>
Date: Sun, 6 Jul 2008 17:44:55 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10724] ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>
In-Reply-To: <uBi7uNfg81L.A.rWD.Z2LcIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	 <uBi7uNfg81L.A.rWD.Z2LcIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 11:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
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
> Date            : 2008-05-16 6:17 (52 days old)
> References      : http://marc.info/?l=linux-kernel&m=121091875711824&w=4
>                  http://lkml.org/lkml/2008/5/18/168
>                  http://lkml.org/lkml/2008/5/25/195
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=16364&action=view
>                  http://bugzilla.kernel.org/attachment.cgi?id=16365&action=view
>
>
>

yes;
>From what I can see so far,  the reason for the gpe storm detector going off
is due to too many interrupts with the battery. As an example there was
a bug filed for the same issue with the macbook's:
https://bugzilla.novell.com/show_bug.cgi?id=301365#c10
using acpi_osi=Darwin does prevent the gpe storm detector from
going off, but you loose any info on the battery. If anybody has any ideas on
modifying any of the battery modules, or adjusting the DSDT it sure
would be appreciated.
regards;

-- 
Justin P. Mattock
