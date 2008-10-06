Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYJFUXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYJFUXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYJFUXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:23:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53921 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbYJFUXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:23:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Theodore Tso <tytso@mit.edu>
X-Fcc: ~/Mail/linus
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, David Smith <dsmith@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
In-Reply-To: Theodore Tso's message of  Saturday, 4 October 2008 11:24:56 -0400 <20081004152456.GB23398@mit.edu>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org>
	<20081003195436.GA13506@Krystal>
	<20081004152456.GB23398@mit.edu>
X-Windows: you'll envy the dead.
Message-Id: <20081006202316.805C51541E4@magilla.localdomain>
Date: Mon,  6 Oct 2008 13:23:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, something we need to consider is getting distributions to ship
> Modules.markers, and where it should be installed.  I would argue that
> it belongs in /lib/modules/`uname -r`, so maybe "make modules_install"
> should put it there?

Fedora kernel RPMs put it in /lib/modules/`uname -r`/build/, which is where
Module.symvers is installed.  This lands it in the kernel-devel RPM, which
is needed to build modules (and hence by Systemtap).

Since new uses of markers won't necessarily require building modules,
your suggestion is probably better.


Thanks,
Roland
