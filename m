Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYJ0FyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYJ0FyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 01:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYJ0FyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 01:54:16 -0400
Received: from smtp1.ist.utl.pt ([193.136.128.21]:49611 "EHLO smtp1.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYJ0FyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 01:54:16 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2008 01:54:16 EDT
From: Claudio Martins <ctpm@ist.utl.pt>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: Order 0 page allocation failure under heavy I/O load
Date: Mon, 27 Oct 2008 06:47:31 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20081026225723.GO18495@disturbed>
In-Reply-To: <20081026225723.GO18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810270547.31123.ctpm@ist.utl.pt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 October 2008, Dave Chinner wrote:

> The host will hang for tens of seconds at a time with both CPU cores
> pegged at 100%, and eventually I get this in dmesg:
>
> [1304740.261506] linux: page allocation failure. order:0, mode:0x10000
> [1304740.261516] Pid: 10705, comm: linux Tainted: P          2.6.26-1-amd64

 Hello,

 Have you tried to increase vm.min_free_kbytes to something higher, that is 
>=30000?

 I think I have hit something similar on a box running nbd-server to export a 
3 SATA disk raid0 block device over Gigabit Ethernet.
 Increasing min_free_kbytes got rid of the messages for me... Though the load 
on your system is much higher than on mine.

 Regards

Cláudio

