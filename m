Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbXFQVHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbXFQVHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 17:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXFQVHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 17:07:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXFQVHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 17:07:22 -0400
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Gabor Czigola <czigola@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <3a0f49600706171014m6bc9af34s9dda0ea282a4d63@mail.gmail.com>
	<orfy4qh0mc.fsf@oliva.athome.lsd.ic.unicamp.br>
	<1182112097.3800.3.camel@gimli.at.home>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 18:07:00 -0300
In-Reply-To: <1182112097.3800.3.camel@gimli.at.home> (Bernd Petrovitsch's message of "Sun\, 17 Jun 2007 22\:28\:17 +0200")
Message-ID: <orfy4qffyj.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Bernd Petrovitsch <bernd@firmix.at> wrote:

> On Sun, 2007-06-17 at 15:55 -0300, Alexandre Oliva wrote:
>> On Jun 17, 2007, "Gabor Czigola" <czigola@gmail.com> wrote:
>> 
>> > I wonder why the linux kernel development community couldn't propose
>> > an own GPL draft (say v2.2) that is "as free as v2" and that includes
>> > some ideas (from v3) that are considered as good (free, innovative, in
>> > the spirit of whatever etc.) by the majority of the kernel developers.
>> 
>> For one, because the text of the GPL is copyrighted by the FSF, and
>> licensed without permission for modification.  And that's as it should
>> be, you don't want others to modify the terms of the license you chose
>> for your code, do you?

> That's probably precisely the reason for removing the "or later" so that
> others (even if it's "only" the FSF) can't modify the terms of the
> license chosen for the code.

Yes, if you don't trust the organization entitled to publish revised
versions to abide by its commitment to abide by a similar spirit, or
if that spirit does not reflect your intent as a copyright holder,
this are all rational reasons to remove the "or later", indeed (at
least as much as distrust can be regarded as rational, that is ;-)


However, as Ingo argued, not being able to patch holes, fix bugs and
add new features is a very bad idea.  He was talking about the
software, but this is as true when it comes to the license.

There are smarter ways of retaining control over licensing terms that
don't paint yourself into a corner that's nearly impossible to get out
of.

For example, the license provisions could state "or any later version
that CONDITION", where CONDITION reflects your intent as a copyright
holder, or it could state "or any other license that CONDITION."

They could also appoint a committee, or rules for formation of a
committee, to make this sort of decisions on behalf of all the
copyright holders involved.

Of course, since these are in fact all additional permissions, anyone
could take them out, or rather elect not to offer this option for
their own contributions (and then you might end up refraining from
merging them).

The mechanics are no different from "or any later version" provisions,
really, except that then you establish what the goals of your
community are without blocking upgrades that wouldn't conflict, but
that would rather further the interests of your own community.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
