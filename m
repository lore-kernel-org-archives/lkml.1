Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXLHJwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXLHJwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbXLHJwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:52:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46135 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755449AbXLHJwl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:52:41 -0500
Date: Sat, 8 Dec 2007 01:52:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208015227.3a1c7fae.akpm@linux-foundation.org>
In-Reply-To: <200712080340.49546.rjw@sisk.pl>
References: <200712080340.49546.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 03:40:49 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message contains a list of some regressions from 2.6.23 which have been
> reported since 2.6.24-rc1 was released and for which there are no fixes in the
> mainline that I know of.  If any of them have been fixed already, please let me
> know.
> 
> If you know of any other unresolved regressions from 2.6.23, please let me know
> either and I'll add them to the list.
> 
> ...
> 
> Subject		: cd/dvd inaccessible in 2.6.24-rc2
> Submitter	: Will Trives <will@trivescon.com.au>
> References	: http://lkml.org/lkml/2007/11/9/290
> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
> Handled-By	: Len Brown <lenb@kernel.org>
> 		  Tejun Heo <htejun@gmail.com>
> Patch		: 
> 

Nasty one.  Tejun and several diligent reporters are doing sterling work
there and things have improved.  I don't know whether any of Tejun's
patches have been merged yet, but we'll probably be OK on this one.

What is unclear (to me) is what actually caused those people's machines to
break?

