Return-Path: <linux-kernel-owner+w=401wt.eu-S1764712AbXGTUoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764712AbXGTUoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXGTUn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:43:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477AbXGTUn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:43:58 -0400
Message-ID: <46A11E7D.90209@redhat.com>
Date: Fri, 20 Jul 2007 16:43:41 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6.21.1] totally hanging altough not crashed
References: <20070720195252.GA25317@vanheusden.com>
In-Reply-To: <20070720195252.GA25317@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2007 03:53 PM, Folkert van Heusden wrote:
> Hi,
> 
> One of my systems running 2.6.21.1 on a P4 with HT and 2GB of ram
> occasionally crashes. Not with an oops or panic, it just suddenly stops
> doing anything. It still lets you ping and it still forwards ip traffic
> but you can't login: not via ssh and not on the console - pressing enter
> brings the cursor to the next line and that's it. It is NOT swapping at
> all, in fact alt+sysrq+m says that there's still plenty of memory and
> swap available:

Lots of processes are in uninterruptible wait at
start_this_handle+0x208/0x365. Can you find out what line of code
that matches? (There are a few of those waits in that function.)
