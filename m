Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbYETQUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbYETQUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 12:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756454AbYETQUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 12:20:42 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:39852 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbYETQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 12:20:41 -0400
Message-ID: <4832FA80.7060807@freescale.com>
Date: Tue, 20 May 2008 11:21:20 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Rune Torgersen <runet@innovsys.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Subject: Re: Oops in fs_enet driver with preempt-rt
References: <DCEAAC0833DD314AB0B58112AD99B93B046E728C@ismail.innsys.innovsys.com> <DCEAAC0833DD314AB0B58112AD99B93B046E72C3@ismail.innsys.innovsys.com> <4832F139.1020502@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B046E73C6@ismail.innsys.innovsys.com>
In-Reply-To: <DCEAAC0833DD314AB0B58112AD99B93B046E73C6@ismail.innsys.innovsys.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rune Torgersen wrote:
> Hmm.... ttyCPM1 output seems to be kinda garbled... Any ideas?
> Incomplete locking between printk and userland use of ttyCPM1 as
> console?

s/incomplete/nonexistent/ :-P

Try acquiring port->lock in cpm_uart_console_write.

-Scott
