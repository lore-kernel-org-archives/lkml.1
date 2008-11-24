Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbYKXTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbYKXTJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYKXTJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:09:06 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44828 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYKXTJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:09:04 -0500
Message-ID: <492AFBCD.2020009@s5r6.in-berlin.de>
Date: Mon, 24 Nov 2008 20:09:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Jay Fenlason <fenlason@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: idr: IDs guaranteed to be less than 1<<31? (was Re: [PATCH] firewire:
 us an idr rather than a linked list for resources)
References: <20081124163728.GA5826@redhat.com>
In-Reply-To: <20081124163728.GA5826@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Fenlason wrote at linux1394-devel:
> As mentioned in the comments, there is a theoretical problem with this
> code if someone manages to allocate 2^31 resources on a 32-bit
> machine, or 2^32+1 resources on a 64+-bit machine.

The kerneldoc of idr_get_new() says that we only get IDs in the range of
0...0x7fffffff.  But is this true with 64bit kernels?
-- 
Stefan Richter
-=====-==--- =-== ==---
http://arcgraph.de/sr/
