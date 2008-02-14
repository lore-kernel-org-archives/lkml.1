Return-Path: <linux-kernel-owner+w=401wt.eu-S1765344AbYBNUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765344AbYBNUKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757236AbYBNUKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:10:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60237 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbYBNUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:10:41 -0500
Date: Thu, 14 Feb 2008 12:09:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples: build fix
Message-Id: <20080214120920.e3eab2d9.randy.dunlap@oracle.com>
In-Reply-To: <20080214200257.42815270195@magilla.localdomain>
References: <20080214034541.EF1BD270192@magilla.localdomain>
	<20080214132752.GA27478@Krystal>
	<20080214194633.GA21894@uranus.ravnborg.org>
	<20080214200257.42815270195@magilla.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 12:02:57 -0800 (PST) Roland McGrath wrote:

> I don't have any axe to grind here, I just could not figure out how to get
> the samples/ modules built (without resorting to make M=.../samples/foo and
> clobbering my source directory).  If there is another plan, point me to its
> documentation.  I can't see the point of the Kconfig option for samples at all.
> What does it do?
> 
> Because they are only ever modules, the samples are never built in.  I
> honestly don't see why the modules shouldn't be installed like any others.
> People who are really going to install the kernel for production are not
> going to set this Kconfig option.

There used to be a make target called "samples_check" (I could have
misspelled it).  Where did it go?  Sam?

---
~Randy
