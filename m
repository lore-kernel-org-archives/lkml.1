Return-Path: <linux-kernel-owner+w=401wt.eu-S965456AbXAYSYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbXAYSYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965566AbXAYSYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:24:40 -0500
Received: from chen.mtu.ru ([195.34.34.232]:2150 "EHLO chen.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965456AbXAYSYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:24:39 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [patch] suspend debugging: simulate suspend-to-RAM
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Thu, 25 Jan 2007 21:03:22 +0300
References: <20070125113350.GA31068@elte.hu>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20070125180324.36E8B557CF8@chen.mtu.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Make debugging such bugs easier by offering a resume mode that does not
> actually call into the BIOS to turn off the machine. This, in
> combination with earlyprintk=serial,ttyS0,115200,keep ,
> CONFIG_PM_DEBUG=y, CONFIG_DISABLE_CONSOLE_SUSPEND=y and
> /sys/power/filter enables me to have a fully functional serial console
> during the full suspend/resume cycle.
>

Will it work with netconsole too? COM port is often missing in notebooks
today.

-andrey


