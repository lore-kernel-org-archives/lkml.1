Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbYBRNEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbYBRNEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbYBRNCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:02:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760948AbYBRNCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:02:36 -0500
Date: Mon, 18 Feb 2008 05:01:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc2] stack trace immediately before rebooting/switching
 off
Message-Id: <20080218050107.ecb1d050.akpm@linux-foundation.org>
In-Reply-To: <200802171516.57468.arvidjaar@mail.ru>
References: <200802171516.57468.arvidjaar@mail.ru>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 15:16:53 +0300 Andrey Borzenkov <arvidjaar@mail.ru> wrote:

> In 2.6.25 I get stack trace immediately before system is switched off or
> reboots. It is too fast to capture it on VGA; netconsole does not capture
> it either - probably network is already shutdown at this point. I do
> not have serial port on this system.
> 
> Any idea how could I capture it? Thank you.
> 
> The problem did not exist in 2.6.24 and below. 
> 

- put an mdelay(100000) into sys_reboot() somewhere, take photo of screen

- try plain old /sbin/halt, see if that does it as well.
