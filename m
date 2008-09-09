Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYIIRvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYIIRvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756232AbYIIRu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:50:58 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43188 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYIIRu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:50:57 -0400
Subject: Re: [RFC] [PATCH -mm] cgroup: limit the amount of dirty file pages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: righi.andrea@gmail.com
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       David Radford <dradford@bluehost.com>,
       Marco Innocenti <m.innocenti@cineca.it>,
       Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, linux-mm@kvack.org,
       Divyesh Shah <dpshah@google.com>, Matt Heaton <matt@bluehost.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naveen Gupta <ngupta@google.com>
In-Reply-To: <48C6987D.2050905@gmail.com>
References: <48C6987D.2050905@gmail.com>
Content-Type: text/plain
Date: Tue, 09 Sep 2008 10:49:44 -0700
Message-Id: <1220982584.23386.219.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-09 at 17:38 +0200, Andrea Righi wrote:
> It allows to control how much dirty file pages a cgroup can have at any
> given time. This feature is supposed to be strictly connected to a
> generic cgroup IO controller (see below).

So, this functions similarly to our global dirty ratio?  Is it just
intended to keep a cgroup from wedging itself too hard with too many
dirty pages, just like the global ratio?

-- Dave

