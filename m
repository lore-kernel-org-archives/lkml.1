Return-Path: <linux-kernel-owner+w=401wt.eu-S1751942AbZHZTQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbZHZTQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZHZTQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:16:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbZHZTQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:16:21 -0400
Date: Wed, 26 Aug 2009 12:16:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@intel.com,
       rui.zhang@intel.com
Subject: Re: [PATCH 1/2] ACPI processor: force throttling state when BIOS
 returns incorrect value
Message-Id: <20090826121619.2bc7e72b.akpm@linux-foundation.org>
In-Reply-To: <200908171443.35622.elendil@planet.nl>
References: <200908171443.35622.elendil@planet.nl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 14:43:34 +0200
Frans Pop <elendil@planet.nl> wrote:

> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -62,7 +62,8 @@ struct throttling_tstate {
>  #define THROTTLING_POSTCHANGE      (2)
>  
>  static int acpi_processor_get_throttling(struct acpi_processor *pr);
> -int acpi_processor_set_throttling(struct acpi_processor *pr, int state);
> +int acpi_processor_set_throttling(struct acpi_processor *pr,
> +						int state, bool force);
>  

WARNING: externs should be avoided in .c files
#74: FILE: drivers/acpi/processor_throttling.c:65:
+int acpi_processor_set_throttling(struct acpi_processor *pr,

total: 0 errors, 1 warnings, 137 lines checked

checkpatch speaketh truth - there's already a declaration in
acpi/processor.h anyway.

I'll leave it alone though.  Cleaning up acpi code isn't on the agenda
for today.

Please integrate checkpatch into your patch preparation tools.  It
finds stuff.
