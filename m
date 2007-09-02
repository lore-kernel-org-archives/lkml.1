Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbXIBDrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbXIBDrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 23:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXIBDq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 23:46:56 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:48971 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbXIBDq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 23:46:56 -0400
Subject: Re: [PATCH 2/5] Use macros instead of TASK_ flags
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <11887012142333-git-send-email-matthew@wil.cx>
References: <20070902024348.GJ14130@parisc-linux.org>
	 <11887012142333-git-send-email-matthew@wil.cx>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 20:35:06 -0700
Message-Id: <1188704106.11196.44.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 22:46 -0400, Matthew Wilcox wrote:
>         */
>         if (task == current) return 0;
>  
> -       if ((task->state != TASK_STOPPED) && (task->state !=
> TASK_TRACED)) {
> +       if (!is_task_stopped_or_traced(task->state)) {
>                 DPRINT(("cannot attach to non-stopped task [%d] state=
> -               if ((task->state != TASK_STOPPED) && (task->state !=
> TASK_TRACED)) {
> +               if (!is_task_stopped_or_traced(task)) {
>                         DPRINT(("[%d] task not in stopped state\n",
> task->pid));
>                         return -EBUSY;
>                 } 

Does it take task->state or task ?

Daniel

