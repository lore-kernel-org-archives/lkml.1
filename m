Return-Path: <linux-kernel-owner+w=401wt.eu-S1759586AbXJYGSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586AbXJYGSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXJYGSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:18:46 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:36922 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753823AbXJYGSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:18:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ickdsRb3oQho6DXLOCdgo7I8hl3I6BYK3kyB1WeLclKO4g4Rnb6E5mCCZayI8FDg4P9p580VnIm9W0txFdb4+C76mq+lP+VuhSPzG3JORkk7MBMpQc2444X3lNGGwDLsjnHHAoWQeI8uz0CVahwuxoi7Eid1XHWAtO9+F0gezpc=  ;
X-YMail-OSG: viqXQvkVM1lDpSZYSRPnee_VV81ukgFmQOW5ZZJF6BZc_ZoHoCsdyfmqlWuk7TVBlwgRcdb_9w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: sysfs sys/kernel/ namespace (was Re: [PATCH 0/2] add new notifier function ,take2)
Date: Thu, 25 Oct 2007 16:12:04 +1000
User-Agent: KMail/1.9.5
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takenori Nagano <t-nagano@ah.jp.nec.com>
References: <471700F4.1080200@ah.jp.nec.com> <200710251231.07185.nickpiggin@yahoo.com.au> <20071025054545.GB15255@kroah.com>
In-Reply-To: <20071025054545.GB15255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251612.04710.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 15:45, Greg KH wrote:
> On Thu, Oct 25, 2007 at 12:31:06PM +1000, Nick Piggin wrote:
> > On Wednesday 24 October 2007 21:12, Kay Sievers wrote:
> > > On 10/24/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > > It was intended to be something like /proc/sys/kernel/ only.
> >
> > Really? So you'd be happy to have a /sys/dev /sys/fs /sys/kernel
> > /sys/net /sys/vm etc? "kernel" to me shouldn't really imply the
> > stuff under the kernel/ source directory or other random stuff
> > that doesn't fit into another directory, but attributes that are
> > directly related to the kernel software (rather than directly
> > associated with any device).
>
> What would you want in /sys/net and /sys/dev and /sys/vm?  I don't mind
> putting subdirs in /sys/kernel/ if you want it.

I guess potentially things that are today in /proc/sys/*. Sysfs is much
closer to the "right" place for this kind of attributes than procfs,
isn't it?


> > It would be nice to get a sysfs content maintainer or two. Just
> > having new additions occasionally reviewed along with the rest of
> > a patch, by random people, doesn't really aid consistency. Would it
> > be much trouble to ask that _all_ additions to sysfs be accompanied
> > by notification to this maintainer, along with a few line description?
> > (then merge would require SOB from said maintainer).
>
> No, I would _love_ that.  We should make the requirement that all new
> sysfs files be documented in Documentation/API/ like that details.

Obviously I'm for that too. A mandatory cc to a linux-abi list,
documentation, and an acked-by from the relevant API maintainers, etc.
All it needs is upstream to agree and sometime to implement it.


> I'll be glad to review it, but as it's pretty trivial to add sysfs
> files, everyone ends up doing it :)

If it fits with the overall direction that yourself / Kay / everyone
else has in mind, then yes. Problem is that if this stuff goes
unreviewed, or reviewed by different people who don't have a coherent
idea of what the API should look like, then it ends in a mess that you
can't fix easily.
