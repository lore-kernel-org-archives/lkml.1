Return-Path: <linux-kernel-owner+w=401wt.eu-S936301AbZAPWue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936301AbZAPWue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbZAPWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:50:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756085AbZAPWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:50:21 -0500
Date: Fri, 16 Jan 2009 14:49:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI suspend: Fix compilation warnings in
 drivers/acpi/sleep.c
Message-Id: <20090116144933.3ed476f9.akpm@linux-foundation.org>
In-Reply-To: <200901162309.14778.rjw@sisk.pl>
References: <200901162309.14778.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 23:09:14 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Fix two compilation warnings in drivers/acpi/sleep.c, one triggered
> by unsetting CONFIG_SUSPEND and the other triggered by unsetting
> CONFIG_HIBERNATION, by moving some code under the appropriate
> #ifdefs .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/acpi/sleep.c |    4 +--
>  drivers/acpi/sleep.c         |   51 +++++++++++++++++++++----------------------

Confused.  drivers/acpi/sleep.c was removed six years ago?
