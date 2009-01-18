Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZARWgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZARWgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZARWga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:36:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56153 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZARWg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:36:29 -0500
Date: Mon, 19 Jan 2009 07:36:19 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: lirc@bartelmus.de (Christoph Bartelmus)
Subject: Re: get_task_comm() not exported?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <AtzdCwOXqgB@lirc>
References: <AtzdCwOXqgB@lirc>
Message-Id: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi,
> 
> is there any reason why get_task_comm() is not exported in fs/exec.c?

In general, the only function of anybody necessarity explained is exported.
if you want to export get_task_comm(), you need to explain reasonable reason.

> 
> I'd like to use get_task_comm() from a kernel module and get unresolved  
> symbol errors.
> 
> Adding EXPORT_SYMBOL(get_task_comm); to fs/exec.c fixes the problem.
> 
> Cheers,
> Christoph
> 
> Please Cc.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



