Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbXLHElI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbXLHElI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 23:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXLHEk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 23:40:56 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57041 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbXLHEkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 23:40:55 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org,
       "Denis V. Lunev" <den@openvz.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
In-Reply-To: <20071208000043.GC1951@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Sat, 8 Dec 2007 03:00:43 +0300")
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	<1197067918.10831.13.camel@heimdal.trondhjem.org>
	<20071207151444.af5d8e11.akpm@linux-foundation.org>
	<200712080043.29292.rjw@sisk.pl>
	<20071208000043.GC1951@martell.zuzino.mipt.ru>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Fri, 07 Dec 2007 21:39:19 -0700
Message-ID: <m1fxydpzpk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:

> I very much agree. ->shadow_proc is so ugly, so it's not funny anymore.
> Adding such hook for proc part of networking _and_ for modules is just asking
> for trouble as was demonstrated.

Alexey however we do this we fundamentally have to proc_lookup, if
we don't want weird artifacts showing up in user space.

To me the implementation details don't much matter, as long as we
somehow get proc_lookup to do the right thing.

Eric
