Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbZJSRoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbZJSRoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 13:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZJSRoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 13:44:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38105 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZJSRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 13:44:12 -0400
Date: Mon, 19 Oct 2009 10:44:05 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: mtk.manpages@gmail.com, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Message-ID: <20091019174405.GE27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091016180631.GA31036@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 11:06:31AM -0700, Sukadev Bhattiprolu wrote:
> Michael Kerrisk [mtk.manpages@googlemail.com] wrote:
> | Hi Sukadev
> | 
> | On Fri, Oct 16, 2009 at 6:20 AM, Sukadev Bhattiprolu
> | <sukadev@linux.vnet.ibm.com> wrote:
> | > Here is an updated patch with the following interface:
> | >
> | >        long sys_clone3(unsigned int flags_low, struct clone_args __user *cs,
> | >                        pid_t *pids);
> | >
> | > There are just two other (minor) changes pending to this patchset:
> | >
> | >        - PATCH 7: add a CLONE_UNUSED bit to VALID_CLONE_FLAGS().
> | >        - PATCH 10: update documentation to reflect new interface.
> | >
> | > If this looks ok, we repost entire patchset next week.
> | 
> | I know I'm late to this discussion, but why the name clone3()? It's
> | not consistent with any other convention used fo syscall naming,
> | AFAICS. I think a name like clone_ext() or clonex() (for extended)
> | might make more sense.
> 
> Sure, we talked about calling it clone_extended() and I can go back
> to that.
> 
> Only minor concern with that name was if this new call ever needs to
> be extended, what would we call it :-). With clone3() we could add a
> real/fake parameter and call it clone4() :-p

Perhaps clone64 (somewhat like stat64 for example)?

Cheers,
	-Matt Helsley
