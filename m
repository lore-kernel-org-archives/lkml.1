Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbZJNBkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbZJNBkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 21:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760274AbZJNBkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 21:40:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54895 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbZJNBkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 21:40:18 -0400
Date: Tue, 13 Oct 2009 18:39:36 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       arnd@arndb.de, Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-api@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091014013936.GC27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD511F1.7010207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD511F1.7010207@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:49:05PM -0700, H. Peter Anvin wrote:
> On 10/12/2009 09:49 PM, Sukadev Bhattiprolu wrote:
> > 
> > This patchset implements a new system call, clone3() that lets a process
> > specify the pids of the child process.
> > 
> 
> A system call named clone3() taking two parameters is just too weird to
> live.  No, please.

Except we can't use clone2() because it conflicts on ia64.  Care to propose
a name you would prefer?

Also I was a bit suprised to discover there are plenty of examples where this
convention has not been followed: vm86, lseek64, and mmap2 to name a few. In
fact, of the 46 __NR_foo[[:digit:]]+, 36 break this convention on x86-32.

Cheers,
	-Matt Helsley
