Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZHZStL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZHZStL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 14:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbZHZStL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 14:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZHZStK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 14:49:10 -0400
Subject: Re: BUG: scheduling while atomic in acpi_ps_complete_op
From: Eric Paris <eparis@redhat.com>
To: ykzhao <yakui.zhao@intel.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
In-Reply-To: <1251295984.3623.83.camel@localhost.localdomain>
References: <1250873707.2168.38.camel@dhcp231-106.rdu.redhat.com>
	 <4A8EFFB2.4040100@suse.de>
	 <1250886352.2168.83.camel@dhcp231-106.rdu.redhat.com>
	 <4A8F1081.3020803@suse.de>
	 <1251124609.2359.25.camel@dhcp231-106.rdu.redhat.com>
	 <1251248426.3623.47.camel@localhost.localdomain>
	 <1251287895.2270.25.camel@dhcp231-106.rdu.redhat.com>
	 <1251295984.3623.83.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Aug 2009 14:48:50 -0400
Message-Id: <1251312530.2280.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 22:13 +0800, ykzhao wrote:
> On Wed, 2009-08-26 at 19:58 +0800, Eric Paris wrote:
> > On Wed, 2009-08-26 at 09:00 +0800, ykzhao wrote:
> > > On Mon, 2009-08-24 at 22:36 +0800, Eric Paris wrote:
> > > > On Sat, 2009-08-22 at 01:24 +0400, Alexey Starikovskiy wrote:
> > > > > Eric Paris пишет:
> > 
> > > > It does stop my slew of warnings.  Not sure it completely fixes my
> > > > problems though....
> > > Will you please add the boot option of initcall_debug and attach the
> > > output of dmesg?
> > > It will be helpful if you can attach the output of acpidump.
> > > Thanks.
> Hi
> 	Will you please confirm whether this issue happens on the 2.6.31-rc6
> kernel?

I just went back to a -rc7 kernel (but a largely different .config) and
it did not happen.

> 	If there is no such issue, will you please revert the following commit
> and see whether the issue still exists?
>    >commit 74b5820808215f65b70b05a099d6d3c969b82689

I reverted
74b5820808215f65b70b05a099d6d3c969b82689 and
773c0ef52ae8dd375b877c51bc6e8d03fb0b59b7

but still see the same problem.  I will try to build a -rc7 kernel with
a similar config for a fair comparison.  If it works, I'll start a git
bisect.

-Eric

