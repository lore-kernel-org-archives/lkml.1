Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYHLBXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYHLBXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 21:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYHLBW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 21:22:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:17735 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYHLBW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 21:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="605946679"
Subject: Re: [PATCH -v2 7/8] kexec jump: ftrace_enabled_save/restore
From: Huang Ying <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080811135136.GD28030@redhat.com>
References: <1218178368.22039.80.camel@caritas-dev.intel.com>
	 <20080808141700.GF3840@redhat.com>
	 <alpine.DEB.1.10.0808081026240.22796@gandalf.stny.rr.com>
	 <1218417741.30464.23.camel@caritas-dev.intel.com>
	 <20080811135136.GD28030@redhat.com>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 09:22:53 +0800
Message-Id: <1218504173.24951.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Vivek,

On Mon, 2008-08-11 at 09:51 -0400, Vivek Goyal wrote:
[...]
> So you want to use a non-locked version from optimization point of view?
> So that we don't end up taking and release a lock?

Not from optimization point of view. machine_kexec() may be called from
crash_kexec(), where it is not permitted to take and release a lock.

Best Regards,
Huang Ying


