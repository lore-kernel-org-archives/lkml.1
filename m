Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZELUIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZELUIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 16:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZELUId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 16:08:33 -0400
Received: from dd2934.kasserver.com ([85.13.129.136]:43685 "EHLO
	dd2934.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZELUId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 16:08:33 -0400
Message-ID: <4A09D740.4000601@datenparkplatz.de>
Date: Tue, 12 May 2009 22:08:32 +0200
From: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: whole system lock-up on low memory
References: <4A076A1F.4080300@datenparkplatz.de> <20090512135800.D62F.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090512135800.D62F.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> mm, I don't reproduce this.
> my test environment:
> 
> kernel: 2.6.30-rc4-mmotm
> CPU: ia64 x 8
> MEM: 8GB


I've never tested on an ia64 system, only on x86 and x86-64.


Sometimes more than one try is needed to yield the behaviour.

And I only had the problem with cryptographic or disabled swap.


E.g. with an /etc/crypttab like this:
swapMapping /dev/sdxx /dev/urandom swap

and /etc/fstab:
/dev/mapper/swapMapping  none  swap  sw  0  0
