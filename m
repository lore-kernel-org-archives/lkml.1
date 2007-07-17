Return-Path: <linux-kernel-owner+w=401wt.eu-S934412AbXGQR7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934412AbXGQR7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934500AbXGQR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:58:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56591 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933391AbXGQR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:58:42 -0400
Date: Tue, 17 Jul 2007 10:58:40 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul (=?ISO-8859-1?Q?=5F=5F=5F=5F=5F=5F?=) Menage" 
	<menage@google.com>
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: Containers: css_put() dilemma
Message-Id: <20070717105840.1e25c7ce.pj@sgi.com>
In-Reply-To: <6599ad830707171055ua1e1135ief95a5ff3cf9dfc9@mail.gmail.com>
References: <469BBE00.8000709@linux.vnet.ibm.com>
	<6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	<469C2792.6050009@linux.vnet.ibm.com>
	<6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	<20070717070031.GA22410@linux.vnet.ibm.com>
	<6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	<469C99D1.7090807@linux.vnet.ibm.com>
	<6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	<469CFF2B.1080702@linux.vnet.ibm.com>
	<20070717105341.9e51cc79.pj@sgi.com>
	<6599ad830707171055ua1e1135ief95a5ff3cf9dfc9@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Right, that's what the release agent patch for process containers does
> - there's a file in the hierarchy root called "release_agent" that
> contains the path to the program to run if a notify_on_release
> container goes idle. When you mount the "cpuset" filesystem, it
> automatically populates that file with "/sbin/cpuset_release_agent".

Cool -- thanks.  Sounds good.

Nevermind my other "what's the Subject" query, if you haven't
already answered it.  You just nicely answered my questions.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
