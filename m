Return-Path: <linux-kernel-owner+w=401wt.eu-S1753376AbZI2SGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbZI2SGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZI2SGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:06:18 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40296 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbZI2SGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:06:17 -0400
Date: Tue, 29 Sep 2009 11:05:37 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Cc: linux-api@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Message-ID: <20090929180537.GD4625@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com> <20090924170308.GH16989@us.ibm.com> <200909242343.59903.arnd@arndb.de> <20090925082346.GB4436@localdomain> <20090925105632.GG12824@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925105632.GG12824@hawkmoon.kerlabs.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing kosaki.motohiro@jp.fujitsu.com and linux-api on this thread.

Louis Rilling [Louis.Rilling@kerlabs.com] wrote:
| > It will very likely break ia64, which defines CONFIG_HAVE_ARCH_TRACEHOOK and
| > already has sys_clone2().
| 
| -> sys_clone_ext() ?
| 
| Louis

How about spelling out extended and calling it clone_extended() ?

The other options I can think of are clone_with_pids() and clone3().

Thanks for your feedback.

Sukadev
