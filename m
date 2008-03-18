Return-Path: <linux-kernel-owner+w=401wt.eu-S936448AbYCSVKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936448AbYCSVKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761875AbYCST71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36142 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761850AbYCST7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:25 -0400
Date: Wed, 19 Mar 2008 00:52:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, nigel@nigel.suspend2.net,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
Message-ID: <20080318235238.GA1779@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803121055510.4595-100000@iolanthe.rowland.org> <200803131803.31120.rjw@sisk.pl> <m1ejaew7dm.fsf@ebiederm.dsl.xmission.com> <200803140231.39282.rjw@sisk.pl> <m1prtsug2e.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prtsug2e.fsf@ebiederm.dsl.xmission.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does using the S4 state have advantages that I currently do not
> see?

Yes. S5 confuses BIOSes on some machines (HP nx5000), and they report
stale values for AC/battery power (and worse, like thermal management
broken).

But this should not stop kexec/kjump.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
