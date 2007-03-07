Return-Path: <linux-kernel-owner+w=401wt.eu-S932498AbXCGEYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbXCGEYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbXCGEYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:24:32 -0500
Received: from morbo.e-centre.net ([66.154.82.3]:64116 "EHLO
	cubert.e-centre.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932498AbXCGEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:24:31 -0500
X-ASG-Debug-ID: 1173241454-16985-248-0
X-Barracuda-URL: http://10.3.1.19:8000/cgi-bin/mark.cgi
X-ASG-Orig-Subj: Re: [PATCH] proc: maps protection
Subject: Re: [PATCH] proc: maps protection
From: Arjan van de Ven <arjan@linux.intel.com>
To: Kees Cook <kees@outflux.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070307031429.GU9621@outflux.net>
References: <20070307012234.GN9621@outflux.net>
	 <20070306175609.267bd7a9.akpm@linux-foundation.org>
	 <20070307021335.GR9621@outflux.net>
	 <20070306185942.585e7cd1.akpm@linux-foundation.org>
	 <20070307031429.GU9621@outflux.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Mar 2007 20:22:11 -0800
Message-Id: <1173241331.3236.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=4.0 tests=
X-Barracuda-Spam-Report: Code version 3.02, rules version 3.0.35859
	Rule breakdown below  pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> [Adding Cc:lkml]

> How about using a reduced check, as is done for fd and environ?  This 
> would allow root-running system monitors to still do their job.  
> Effectively, this changes the test from "is ptracing" to just "can 
> ptrace".
> 
> If this still isn't considered safe, I'll add the maps_protect file...


btw I consider it an information leak that any user can see which
files/libraries any other user and root has mmap'd. (and with glibc's
stdio mmap feature that goes even beyond direct mmap to fopen()'d).

If root or some other user wants to watch
hillary-vs-obama-in-the-mud.avi, no other user has ANY business even
seeing that. So at minimum it's a privacy issue showing the filenames...
