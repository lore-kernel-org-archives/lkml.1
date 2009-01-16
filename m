Return-Path: <linux-kernel-owner+w=401wt.eu-S938010AbZAPWe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938010AbZAPWe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbZAPWeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:34:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757700AbZAPWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:34:43 -0500
Date: Fri, 16 Jan 2009 14:34:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: eric.piel@tremplin-utc.net, trenn@suse.de, linux-kernel@vger.kernel.org
Subject: Re: hp accelerometer: add freefall detection
Message-Id: <20090116143404.ccf2d9ee.akpm@linux-foundation.org>
In-Reply-To: <20090116121940.GA30302@elf.ucw.cz>
References: <20090112092839.GA2190@elf.ucw.cz>
	<496B0E5F.1020902@tremplin-utc.net>
	<20090116121940.GA30302@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 13:19:40 +0100
Pavel Machek <pavel@suse.cz> wrote:

> new file mode 100755
> index 0000000..7d17764
> --- /dev/null
> +++ b/Documentation/hwmon/hpfall.c

checkpatch has fun with this file.

>
> ...
>
> -struct acpi_lis3lv02d adev;
> +struct acpi_lis3lv02d adev = {
> +	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
> +};
> +
>  EXPORT_SYMBOL_GPL(adev);

This seems a rather poor name for a globally-visible identifier.
