Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYKGTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYKGTV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYKGTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:21:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752577AbYKGTVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:21:09 -0500
Date: Fri, 7 Nov 2008 11:20:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: djwong@us.ibm.com, khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH 4/5] adt7473: Check inputs from sysfs writes
Message-Id: <20081107112040.0154e093.akpm@linux-foundation.org>
In-Reply-To: <20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
References: <20081107185621.13022.61885.stgit@elm3a70.beaverton.ibm.com>
	<20081107185641.13022.70557.stgit@elm3a70.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 10:56:41 -0800
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> +#define ROUND_DIV(x, divisor)	(((x) + ((divisor) / 2)) / (divisor))

It might make sense to rename this to ROUND_CLOSEST, fix the
double-evaluation and whap it into kernel.h?

