Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbZJPSFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbZJPSFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZJPSFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:05:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55850 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZJPSFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:05:02 -0400
Date: Fri, 16 Oct 2009 11:06:31 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091016180631.GA31036@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk [mtk.manpages@googlemail.com] wrote:
| Hi Sukadev
| 
| On Fri, Oct 16, 2009 at 6:20 AM, Sukadev Bhattiprolu
| <sukadev@linux.vnet.ibm.com> wrote:
| > Here is an updated patch with the following interface:
| >
| >        long sys_clone3(unsigned int flags_low, struct clone_args __user *cs,
| >                        pid_t *pids);
| >
| > There are just two other (minor) changes pending to this patchset:
| >
| >        - PATCH 7: add a CLONE_UNUSED bit to VALID_CLONE_FLAGS().
| >        - PATCH 10: update documentation to reflect new interface.
| >
| > If this looks ok, we repost entire patchset next week.
| 
| I know I'm late to this discussion, but why the name clone3()? It's
| not consistent with any other convention used fo syscall naming,
| AFAICS. I think a name like clone_ext() or clonex() (for extended)
| might make more sense.

Sure, we talked about calling it clone_extended() and I can go back
to that.

Only minor concern with that name was if this new call ever needs to
be extended, what would we call it :-). With clone3() we could add a
real/fake parameter and call it clone4() :-p

Sukadev
