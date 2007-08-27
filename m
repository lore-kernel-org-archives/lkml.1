Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbXH0Sdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbXH0Sdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXH0Sd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:33:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37334 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbXH0Sd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:33:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: <vgoyal@in.ibm.com>, "Konstantin Baydarov" <kbaidarov@ru.mvista.com>,
       "RT" <linux-rt-users@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] kexec: reenable HPET before kexec
References: <20070820205530.1ffd5876@windmill.dev.rtsoft.ru>
	<20070823090845.GA13065@in.ibm.com>
	<20070823154936.3b7ae498@windmill.dev.rtsoft.ru>
	<20070827053656.GC9809@in.ibm.com>
	<653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
Date: Mon, 27 Aug 2007 12:33:00 -0600
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F501522051@scsmsx415.amr.corp.intel.com>
	(Venkatesh Pallipadi's message of "Mon, 27 Aug 2007 11:26:29 -0700")
Message-ID: <m1zm0c4ylf.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> writes:

> - Another thing to try is to disable HPET and boot with PIT in the first
> kernel. Just to check whether PIT never works on this platform or the
> first kernel is doing something to stop PIT. You can try "hpet=disable"
> boot option for that.

I don't know what the original patch looked like.  It doesn't
seem to have made it to any mailling lists to which I'm subscribed.
But I'm wondering of there is a bug in the shutdown routines for
the pit or the hpet that is causing problems.  As this is
a normal kexec those routines will get called.

Eric
