Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888Ab0A0R6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0A0R6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755852Ab0A0R6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:58:49 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:42371 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755829Ab0A0R6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:58:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=cvlXmDnyifYXOnEBFaEUID/JyUoDrzqBIukHLfNP2FqSKizzbjRV/+V5X5zkv/iIKBAOBkl6bDj6f3tdApmhRfkFqLzPUNbds4zloSzfK6hGgwMsNse8W/UxNby42o2L;
Date: Wed, 27 Jan 2010 09:58:32 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wilson" <chris@chris-wilson.co.uk>,
       "Miles Lane" <miles.lane@gmail.com>
Subject: Re: [Bug #15129] [drm:i915_gem_execbuffer] *ERROR*
 i915_gem_do_execbuffer returns -512
Message-ID: <20100127095832.2d8c42b5@jbarnes-piketon>
In-Reply-To: <hE3x9c-4KZM.A.WQF.-JMXLB@chimera>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<hE3x9c-4KZM.A.WQF.-JMXLB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 23:04:39 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15129
> Subject		: [drm:i915_gem_execbuffer] *ERROR* i915_gem_do_execbuffer returns -512
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2010-01-14 23:18 (11 days old)
> References	: http://lkml.org/lkml/2010/1/14/570
> Handled-By	: Chris Wilson <chris@chris-wilson.co.uk>
> 

I think this message has been rightly killed.  Getting -ERESTARTSYS from
this function is perfectly normal, so we shouldn't bother printing a
message about it.

-- 
Jesse Barnes, Intel Open Source Technology Center
