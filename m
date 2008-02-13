Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbYBMXX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbYBMXX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764065AbYBMXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:23:18 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761933AbYBMXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:23:17 -0500
Date: Wed, 13 Feb 2008 15:22:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, kbaidarov@ru.mvista.com,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 4/8] IPMI: Don't grab locks in run-to-completion mode
Message-Id: <20080213152212.814e1868.akpm@linux-foundation.org>
In-Reply-To: <20080213162749.GD9830@minyard.local>
References: <20080213162749.GD9830@minyard.local>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:27:49 -0600
Corey Minyard <minyard@acm.org> wrote:

> This patch prevents deadlocks in IPMI panic handler caused by msg_lock
> in smi_info structure and waiting_msgs_lock in ipmi_smi structure.

Again, what are the newly-added barrier()s for?  Was cpu_relax()
intended?

If a barrier indeed was intended then, as always, each one should have
a comment explaining why it is there.  Because it is frequently hard to
determine what the programmer was trying to do.
