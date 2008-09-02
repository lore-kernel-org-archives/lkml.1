Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYIBAFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYIBAFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYIBAFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:05:20 -0400
Received: from smtp3.ono.com ([62.42.230.176]:13073 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751498AbYIBAFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:05:18 -0400
Date: Tue, 2 Sep 2008 02:04:47 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Finding what is stuck...
Message-ID: <20080902020447.5b48b083@one.home>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I'm running 2.6.27-rc5-git2 on an Aspire One.
The system is in general pretty responsive, but sometimes it just gets
totally stuck. Even the mouse stops. 

It looks related to disk (SSD) access, but I'm not totally sure.
Is there any way to find what is getting stuck ? I know that SSDs can
be slow on write, I don't mind if the system is faster or slower
(it's small :))), but if the speed is constant. That occasional
pauses are strange, like if SSD flushing gets stuck on BKL
(I know, no idea about what I talk...).

I'm using ext3 fs, noop iosched. But as I say, I'm not sure that the
disk writes are the culprit.

Any idea about how to find this ?

TIA

-- 
J.A. Magallon                       \                     Software is like sex:
                                     \               It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux kernel 2.6.23-jam01,  gcc version 4.2.2 20070909
