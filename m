Return-Path: <linux-kernel-owner+w=401wt.eu-S1422940AbXCOQMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422940AbXCOQMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422941AbXCOQMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:12:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35063 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422940AbXCOQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:12:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
References: <20070313040828.GA17893@redhat.com>
	<200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com>
Date: Thu, 15 Mar 2007 10:11:01 -0600
In-Reply-To: <20070313132218.GA25910@redhat.com> (Dave Jones's message of
	"Tue, 13 Mar 2007 09:22:18 -0400")
Message-ID: <m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Tue, Mar 13, 2007 at 10:22:53AM +0100, Rafael J. Wysocki wrote:
>  > On Tuesday, 13 March 2007 05:08, Dave Jones wrote:
>  > > I spent considerable time over the last day or so bisecting to
>  > > find out why an X60 stopped resuming somewhen between 2.6.20 and current
> -git.
>  > > (Total lockup, black screen of death).
>  > 
>  > Do you have CONFIG_TICK_ONESHOT or CONFIG_NO_HZ set?  If you do, could you
>  > please unset them and retest?
>
> I did try with NO_HZ unset, made no difference, I don't recall TICK_ONESHOT.
> I'm in meetings all day, but I'll check when I get home.

I haven't heard anything more on this thread.

I just wanted to double check.  The tree that failed did it include
commits: 
392ee1e6dd901db6c4504617476f6442ed91f72d and
9f35575dfc172f0a93fb464761883c8f49599b7a

Mostly I was wondering if any of my later work to sort out msi 
suspend/resume actually solved anything.

Eric
