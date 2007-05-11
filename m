Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbXEKUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbXEKUst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758807AbXEKUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:48:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42453 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757310AbXEKUsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:48:43 -0400
Date: Fri, 11 May 2007 13:48:52 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: bas.westerbaan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Conveying memory pressure to userspace?
Message-Id: <20070511134852.86b70cd1.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0705111005200.32716@schroedinger.engr.sgi.com>
References: <6880bed30705101756nb5bd0c5s97935b97d07f846a@mail.gmail.com>
	<Pine.LNX.4.64.0705111005200.32716@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> cpusets export a notion of memory pressure to user space. See the cpusets 
> documentation.

If the special cpuset file 'memory_pressure_enabled' is turned on (echo
'1' to it) in the top cpuset, then the special cpuset file
'memory_pressure' that is in all cpusets provides a measure of the rate
of recent page allocation requests by tasks in each cpuset that were
not easily granted off the free list, requiring more aggressive kernel
effort to free up some pages to meet the request.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
