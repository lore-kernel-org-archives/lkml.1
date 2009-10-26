Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZJZV5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZJZV5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZJZV5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:57:04 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44925 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZJZV5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:57:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=alUb8wpXThdgTTJWz3401fyGBLfZRivu0MHUJ5Gmr3l6iGdPtKvVWj6Bx4rf+dNgRI
         XiGRpZARPIjd+e9SVZyh/Mi3eGT1GErJOemLl6b6fIST1IfM6fODgoD4baXepzx7NUjn
         O3BjYdKX6IyOJDA591NLuNMZsbtzZ+iiz3xog=
MIME-Version: 1.0
In-Reply-To: <6dRYo8ss7vL.A.bIH.qre5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.bIH.qre5KB@chimera>
Date: Tue, 27 Oct 2009 01:57:04 +0400
Message-ID: <a4423d670910261457o2e1ccb7t768199dfd9985270@mail.gmail.com>
Subject: Re: [Bug #14375] Intel(R) I/OAT DMA Engine init failed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/26 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14375
> Subject         : Intel(R) I/OAT DMA Engine init failed
> Submitter       : Alexander Beregalov <a.beregalov@gmail.com>
> Date            : 2009-10-02 9:46 (25 days old)
> References      : http://marc.info/?l=linux-kernel&m=125447680016160&w=4
> Handled-By      : Dan Williams <dan.j.williams@intel.com>
> Patch           : http://patchwork.kernel.org/patch/51808/

When I patch reiserfs the bug goes to libata, it means ioatdma works
and libata does not. It looks like inaccurate work with memory
somewhere, but I do not know how to find it.
I cannot reproduce it since 2.6.32-rc3 and I do not see any bugs since then.
