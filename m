Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXC3Vqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXC3Vqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXC3Vqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:46:43 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXC3Vqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:46:43 -0400
Date: Fri, 30 Mar 2007 14:46:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ken Chen" <kenchen@google.com>
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] remove artificial software max_loop limit
Message-Id: <20070330144630.56d81d0d.akpm@linux-foundation.org>
In-Reply-To: <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ahem.

On Fri, 30 Mar 2007 02:25:37 -0700
"Ken Chen" <kenchen@google.com> wrote:

> +static DEFINE_MUTEX(loop_devices_mutex);
> ...
> +	mutex_lock(&loop_device_mutex);

which makes me suspect that you didn't send the patch which you meant to
send, so I'll drop it.

