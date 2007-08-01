Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXHAXtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXHAXtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXHAXtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:49:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989AbXHAXtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:49:22 -0400
Date: Wed, 1 Aug 2007 16:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping
Message-Id: <20070801164831.ed40546d.akpm@linux-foundation.org>
In-Reply-To: <200708012332.48798.rjw@sisk.pl>
References: <200708012328.23939.rjw@sisk.pl>
	<200708012332.48798.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 23:32:48 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> +/*
> + * Used to notify try_to_freeze_tasks() that the refrigerator has been entered
> + * by a task.
> + */
> +static int refrigerator_called;

this is rather icky.
