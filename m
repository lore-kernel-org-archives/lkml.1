Return-Path: <linux-kernel-owner+w=401wt.eu-S970064AbXILRbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970064AbXILRbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765605AbXILRbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:31:24 -0400
Received: from main.gmane.org ([80.91.229.2]:47976 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764878AbXILRbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:31:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dan Stromberg <dstromberglists@gmail.com>
Subject: Re: Building a kernel-source RPM (not a kernel RPM)?
Date: Wed, 12 Sep 2007 10:31:03 -0700
Message-ID: <pan.2007.09.12.17.30.59.597440@gmail.com>
References: <pan.2007.09.12.16.13.41.195991@gmail.com> <1189616966.31502.75.camel@tara.firmix.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: wsip-64-58-157-227.oc.oc.cox.net
User-Agent: Pan/0.14.2 (This is not a psychotic episode. It's a cleansing moment of clarity.)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 19:09:26 +0200, Bernd Petrovitsch wrote:

> On Wed, 2007-09-12 at 09:13 -0700, Dan Stromberg wrote:
>> I sent this to kernel newbies first, and while I got one response there,
>> it answered a different question than the one I was asking...
> 
> Are you sure?

Yes, I'm sure.  The answer over there was "you don't want to do that.  Do
this instead.

>> I'm on a SuSE system.
>> 
>> I'm working on automating the install of said system, but it needs a
>> Linus kernel - 2.6.21.7 specifically, and it needs kernel source too so
>> that we can build modules in the field as needed.
> 
> Find a kernel-source.*.src.rpm or kernel-*.src.rpm or whatever SuSE uses
> for
> nameing convention and reverse engineer the .spec file.
> Fedora BTW abandoned kernel-source* and they have now a website with a
> description
> how to produce a configured kernel source tree (e.g. for out-of-tree
> modules).

So this is as smooth as producing kernel-source RPM's gets?

I might be better off sticking with a .tar.bz2 and repointing symlinks.

>> I see you can make an rpm of a bootable kernel with "make rpm".
> 
> Well, then there must be a .spec file somewhere which just wants to be
> extended.

I'm not sure this is going to be any easier to automate, if that's what's
required.

>> Is there a streamlined way of building a corresponding kernel-source
>> RPM?  Or do people pretty much all just dump the source in /usr/src, and
> 
> Yes, you put all the steps you do by hand into the .spec file. That's
> it.

I may just stick them in a bash script and forget about the RPM.  Or are
there other packages that are going to be cranky, dependencywise, if I
ignore the RPM?

>> manually update symlinks as needed?  If the latter, what symlinks need
>> to be updated?
> 
> Actually nowadays usually there no "sym-link updating" anymore necessary

On OpenSuSE 10.2, there appears to be:

# find / /home -xdev -ls | egrep -- '-> /usr/src/linux'
215641    0 lrwxrwxrwx   1 root     root           26 Sep 11 17:50 /lib/modules/2.6.18.2-34-default/source -> /usr/src/linux-2.6.18.2-34
213786    0 lrwxrwxrwx   1 root     root           45 Sep 11 17:50 /lib/modules/2.6.18.2-34-default/build -> /usr/src/linux-2.6.18.2-34-obj/x86_64/default

> just put the correct ones in /lib/modules/$(uname -r)/ and the full name
> in
> /boot/grub/menu.lst.

Which correct "ones"?  Sometimes pronouns aren't shortcuts :)

Thanks!



