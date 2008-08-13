Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbYHMDux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbYHMDux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYHMDup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:50:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992AbYHMDuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:50:44 -0400
Date: Tue, 12 Aug 2008 20:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -v3 1/7] kexec jump: clean up #ifdef and comments
Message-Id: <20080812204900.db63deaa.akpm@linux-foundation.org>
In-Reply-To: <1218510861.24951.40.camel@caritas-dev.intel.com>
References: <1218510861.24951.40.camel@caritas-dev.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 11:14:21 +0800 Huang Ying <ying.huang@intel.com> wrote:

>  	xchg(&kexec_lock, 0);

kernel/kexec.c: In function 'kernel_kexec':
kernel/kexec.c:1501: warning: value computed is not used

Is there any reason why we cannot use the more conventional
test_and_set_bit() etc, rather than this peculiarity?

Or perhaps spin_trylock?
