Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYDUGdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYDUGdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 02:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYDUGda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 02:33:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48935 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbYDUGda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 02:33:30 -0400
Date: Mon, 21 Apr 2008 01:33:25 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: balbir@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [RFC][-mm] Memory controller hierarchy support (v1)
Message-Id: <20080421013325.03cdd1a8.pj@sgi.com>
In-Reply-To: <6599ad830804190849u31f13191m4dcca4e471493c2b@mail.gmail.com>
References: <20080419053551.10501.44302.sendpatchset@localhost.localdomain>
	<6599ad830804190849u31f13191m4dcca4e471493c2b@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Cpusets could make use of this too, since
> it has to traverse hierarchies sometimes.

Yeah - I suppose cpusets could use it, though
it's not critical.  A fair bit of work already
went into cpusets so that it would not need to
traverse this hierarchy on any critical code path,
or while holding inconvenient locks.

So cpusets shouldn't be the driving motivation
for this, but it will likely be happy to go along
for the ride.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
