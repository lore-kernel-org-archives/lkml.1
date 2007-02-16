Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbXBPOzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbXBPOzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932377AbXBPOzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:55:54 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49418 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbXBPOzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:55:53 -0500
Date: Fri, 16 Feb 2007 15:57:08 +0100
From: Michael Holzheu <holzheu2@linux.vnet.ibm.com>
To: johnpol@2ka.mipt.ru
Cc: akpm@osdl.org, mschwid2@de.ltcfwd.linux.ibm.com, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Using kevent for event logging?
Message-Id: <20070216155708.589cd47a.holzheu2@linux.vnet.ibm.com>
Organization: IBM
X-Mailer: Sylpheed version 1.0.6 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Evgeniy,

On s390 we are looking for a good mechanism to notify userspace
about kernel events. Currently such events are handled with printks
in most cases. There are automation tools, which want to automatically
react on kernel events. To get the event information, these tools are
parsing printks, which is not a really good mechanism for that
purpose.

When I read about kevents, I was wondering, if it could be used to solve
this problem. E.g. it would be possible to put an event number into a
kevent and provide another interface to get the complete event data.

Do you think, that kevent could be used for this purpose?

Michael
