Return-Path: <linux-kernel-owner+w=401wt.eu-S933178AbXAZLRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbXAZLRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 06:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbXAZLRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 06:17:04 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187AbXAZLRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 06:17:01 -0500
Date: Fri, 26 Jan 2007 03:16:54 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Matthew Kirk" <mkirk01@rcn.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: fsync occasionally very slow
Message-Id: <20070126031654.a41fe374.akpm@osdl.org>
In-Reply-To: <001a01c74136$0028ecf0$6600a8c0@charm>
References: <001a01c74136$0028ecf0$6600a8c0@charm>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 05:37:38 -0500
"Matthew Kirk" <mkirk01@rcn.com> wrote:

> I am working on an application that fsync(2) files and directories as
> needed.    I’m seeing intermittent stalls on fsync that can last many
> seconds.

Please generate an all-task backtrace during the stall via:

dmesg -n 8
<wait for a stall>
echo t > /prov/sysrq-trigger
dmesg -s 1000000 > foo

and send foo.
