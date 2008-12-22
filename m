Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbYLVHPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbYLVHPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYLVHPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:15:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:48733 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYLVHPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:15:31 -0500
Message-ID: <494F3E87.1070204@kernel.org>
Date: Mon, 22 Dec 2008 16:15:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Badalian Vyacheslav <slavon@bigtelecom.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Red leds at harddisk bays on SR1530HSH after update to 2.6.27.x
References: <494A34CA.9030906@bigtelecom.ru> <20081219223246.b0aea84d.akpm@linux-foundation.org> <494EF9A1.90002@kernel.org> <494F3D7D.9010002@bigtelecom.ru>
In-Reply-To: <494F3D7D.9010002@bigtelecom.ru>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Dec 2008 07:15:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Badalian Vyacheslav wrote:
> echo 0 > /sys/module/ahci/parameters/ahci_em_messages
> -bash: /sys/module/ahci/parameters/ahci_em_messages: Permission denied
> ls -la /sys/module/ahci/parameters/ahci_em_messages
> -r--r--r-- 1 root root 4096 Dec 22 10:04
> /sys/module/ahci/parameters/ahci_em_messages
> 
> Any other chance to change without it reboot? Or i can change it only at
> boot? I will reboot server at night.

You can unload and reload ahci but that often isn't too different
from rebooting.

-- 
tejun
