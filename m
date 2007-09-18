Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXIRIWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXIRIWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXIRIW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:22:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35879 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751493AbXIRIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:22:25 -0400
Date: Tue, 18 Sep 2007 01:22:19 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: task containersv11 kernel BUG at include/linux/dcache.h:323
Message-Id: <20070918012219.95fa3c1b.pj@sgi.com>
In-Reply-To: <6599ad830709171222u5fb6344aof3777931de7ec8d1@mail.gmail.com>
References: <20070916045438.9585.46625.sendpatchset@jackhammer.engr.sgi.com>
	<6599ad830709171126l7f178404tbb37e916767a3956@mail.gmail.com>
	<20070917121347.345b7d05.pj@sgi.com>
	<6599ad830709171222u5fb6344aof3777931de7ec8d1@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Fix a reference counting bug in containerfs

Tested using my cpuset creation/destruction stress test.

That fixed it - thank!

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
