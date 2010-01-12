Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383Ab0ALWbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0ALWbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 17:31:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959Ab0ALWbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 17:31:07 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47382 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab0ALWbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 17:31:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=n/JdWo5pMzxiGWxUjudLqEF4S8UC3oGCnPhR8cJpPIotqI0/i1iOxLaNxsuqfTGVi8
         MN8jmOva5eVY3osSWDnarq2cJ57rA6u+4uiuixvIJYE8KbyLdQMGI0AkPY/yvUI9ytAH
         hIYtmfca7Ybx63nXrH23fMYLwznEuuZnPYovA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1001121436080.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>
	 <alpine.DEB.2.00.1001121436080.25925@router.home>
Date: Tue, 12 Jan 2010 14:31:02 -0800
X-Google-Sender-Auth: 240a8df06278e68b
Message-ID: <86802c441001121431p6c9bcab9kb8176d8e569ed3e9@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
From: Yinghai Lu <yinghai@kernel.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 12:48 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:

>
> drivers/acpi/numa.c:acpi_numa_init probably should use nr_cpu_ids
> instead now.

you are right.

YH
