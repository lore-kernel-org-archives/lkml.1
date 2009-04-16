Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZDPAUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZDPAUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZDPAUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 20:20:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34724 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148AbZDPAUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 20:20:36 -0400
Message-ID: <49E679D0.7050600@garzik.org>
Date: Wed, 15 Apr 2009 20:20:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: How to completely disable async fastboot?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit

> commit 9710794383ee5008d67f1a6613a4717bf6de47bc
> Author: Arjan van de Ven <arjan@linux.intel.com>
> Date:   Sun Mar 15 11:11:44 2009 -0700
> 
>     async: remove the temporary (2.6.29) "async is off by default" code

not only changes a default, it completely removes the ability to turn 
off async AFAICS.

At present, I need to turn this off to debug boot-time operation.

	Jeff



