Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbZBDQDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbZBDQDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZBDQDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:03:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:17581 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZBDQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rqFzxtiPHDUEaEAb5vueGmKiX/wUl1k5mh55ncXBHWGJ/YuLDQ9N2xyG8dPbnmnxN5
         Gijr4a5aS6SYhFPgZMUgDY6/Pf7BdBDV1W5gd/mzVx3IQ0ryiZQr6CCPRufH+X0U2m+K
         Oq8hGwwQDIXYgvNMif/tBTU2V8xxJ5dsdlO5Q=
MIME-Version: 1.0
In-Reply-To: <pWZw1SZjMCH.A.dvF.SvYiJB@chimera>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <pWZw1SZjMCH.A.dvF.SvYiJB@chimera>
Date: Wed, 4 Feb 2009 09:03:00 -0700
X-Google-Sender-Auth: 1c04a433a141a0ad
Message-ID: <e9c3a7c20902040803p12ffe0bcrced5249c4b667623@mail.gmail.com>
Subject: Re: [Bug #12511] WARNING: at drivers/dma/dmaengine.c:352
From: Dan Williams <dan.j.williams@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 3:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>

This should be resolved as of commit 83436a05 "dmaengine: kill some
dubious WARN_ONCEs"

Thanks,
Dan
