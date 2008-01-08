Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbYAHWj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbYAHWj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYAHWjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:39:20 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3600 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYAHWjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:39:19 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at kernel/lockdep_proc.c:267 lockdep_stats_show()
Date: Tue, 8 Jan 2008 23:39:10 +0100
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801081942.17139.m.kozlowski@tuxland.pl> <20080108130034.8ab82fb0.randy.dunlap@oracle.com>
In-Reply-To: <20080108130034.8ab82fb0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082339.13198.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

> > 	Got this when doing usual looping over /proc entries on fresh test kernel:
> 
> What is the usual looping, please?

#!/bin/bash

for i in `find /proc -type f`; do
        echo -n "cat $i > /dev/null ... ";
        ( cat $i > /dev/null & );
        echo "done";
done

Regards,

	Mariusz
