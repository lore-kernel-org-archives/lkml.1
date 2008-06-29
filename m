Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbYF2UFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbYF2UFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbYF2UEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:38095 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbYF2UEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=XflmJFDXhJpsIf+KW8TgNtunA2WV6Pp4CAS4/M/yvjNsxBsdqAaVK++EeyEqDxVdJb
         kkTUTQqSiOGdxjtA4GM9RgRG85SqXywd73z/hSbi70ZB8M2EeiCuODKQ1in+cd/kcxCF
         r7y455Roh2ftUZfMlwXW0xAKymWsUDKj0MGZU=
Message-ID: <2c0942db0806291304t2f278e7fq65b67519eb56af41@mail.gmail.com>
Date: Sun, 29 Jun 2008 13:04:30 -0700
From: "Ray Lee" <ray@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10959] stuck tcp connections 2.6.26-rc7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Justin Mattock" <justinmattock@gmail.com>
In-Reply-To: <X8mbwW6K81I.A.OtD.769ZIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.OtD.769ZIB@albercik>
X-Google-Sender-Auth: f77b2f6eb6b152e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 11:18 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10959
> Subject         : stuck tcp connections 2.6.26-rc7
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-22 18:09 (8 days old)
> References      : http://marc.info/?l=linux-kernel&m=121415821219644&w=4

Last word on this was that it was traced down to a problem with
madwifi / wpa_supplicant that was independent of kernel version
(reverting to an earlier wpa_supplicant fixed the problem), so I think
this can be closed.
