Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZBUUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZBUUsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 15:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZBUUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 15:48:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZBUUsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 15:48:10 -0500
Date: Sat, 21 Feb 2009 15:48:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       zippel@linux-m68k.org
Subject: Re: [PATCH v2] kconfig: check for select dependency errors on config
 load
In-Reply-To: <alpine.DEB.2.00.0902211535440.18221@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0902211547150.18221@gandalf.stny.rr.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <alpine.DEB.2.00.0902210008580.30069@gandalf.stny.rr.com> <20090220220810.6f4360f0.akpm@linux-foundation.org> <499F9D25.8010300@oracle.com> <alpine.DEB.2.00.0902211504200.30069@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0902211535440.18221@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 21 Feb 2009, Steven Rostedt wrote:
> 
> Hmm, that I2C_ALGOBIT depends on I2C_HELPER_AUTO, which looks similar to 
> the EMBEDDED option. That is, Don't show this option unless this is not 
> selected. I may just add a 'WHITELIST' of things that will be enabled 
> during thet test.

It is actually the opposite of EMBEDDED. It is, show this item if 
I2C_HELPER_AUTO is _not_ selected.

-- Steve

