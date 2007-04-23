Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXDWMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXDWMUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXDWMUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:20:08 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:42981 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbXDWMUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:20:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GD0xFiUi9CvfYCaEEM1cdwy/8WlEZRQEYrUGftNfO9d4bhBnqHyk5r3JxN4H5e19GUTU94rO8cwODMYYWPD5/5deZMGvTqNxRVh23F9UNia29oIp0N7f2U4v7000NxtjDrJuIg3VgEuaCVZT9xEZtzOAwYlbVlwQo+HnrD9r/ek=
Message-ID: <3d8471ca0704230520w5f395747v2bfb121f7f891f32@mail.gmail.com>
Date: Mon, 23 Apr 2007 14:20:05 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v5
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070423011229.GA20367@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
X-Google-Sender-Auth: 997ce4fe3b33960a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/23, Ingo Molnar <mingo@elte.hu>:

Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
+#include "sched_stats.h"
+#include "sched_rt.c"
+#include "sched_fair.c"
+#include "sched_debug.c"

Index: linux/kernel/sched_stats.h
===================================================================
--- /dev/null
+++ linux/kernel/sched_stats.h

These look unnatural if it were to be included in mainline.

WBR.

-- 
Guillaume
