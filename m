Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbXFQISr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbXFQISr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXFQISe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:18:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbXFQISc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:18:32 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Rob Landley <rob@landley.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<20070614122031.4751a52b@the-village.bc.nu>
	<20070614122546.GB22078@elte.hu> <200706141907.11957.rob@landley.net>
	<20070615120926.GD6269@elte.hu>
	<orvedp121p.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615214804.GC4996@elte.hu>
	<or3b0svjc5.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070617073820.GA6267@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Sun, 17 Jun 2007 05:17:57 -0300
In-Reply-To: <20070617073820.GA6267@elte.hu> (Ingo Molnar's message of "Sun\, 17 Jun 2007 09\:38\:20 +0200")
Message-ID: <ory7ijhu4q.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

>> On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:
>> 
>> >>> it irreversibly cuts off certain people from being to distribute
>> >>> GPLv3-ed software alongside with certain types of hardware that 
>> >>> the FSF's president does not like.
>> >>>
>> >> That's not true.  They can just as well throw the key away and 
>> >> refrain from modifying the installed software behind the users' 
>> >> back.
>> 
>> > uhm, so you claim that my argument is false, and your proof for that 
>> > is a "non-upgradeable Tivo"?? <sarcasm> That is a _great_ idea. Not 
>> > being able to patch security holes. Not being able to fix bugs. Not 
>> > being able to add new features. Makes complete sense.
>> 
>> Oh, so you think patching security holes, fixing bugs and adding new 
>> features are good ideas?  What if you can't do it in your TiVo?

> this has to be one of the most bizarre arguments i've read in this 
> thread as of date. Are you seriously questioning the notion that it's a 
> good and legitimate idea for a hardware vendor to make the system 
> fixable, patchable and upgradable?

No.  I'm questioning why the vendor could keep this privilege to
itself.

> Are you seriously suggesting that for a hardware vendor to be able
> to offer such a solution, if they are under the unescapable
> restriction of content providers that the system itself must be
> tamper-proof, it should not be able to use a GPL-ed kernel at all?

No, and I've already explained how I believe this can be accomplished
with the wording in the GPLv3dd4, although IANAL to tell whether
that's correct.

Just make the tivoization machinery require two keys: one that the
vendor keeps, one that the vendor gives to the user (maybe without
ever knowing it).  Neither one can install modifications alone, but
the user can approve modifications by the vendor, and the vendor can
approve modifications by the user.  This is still not ideal, but it at
least doesn't permit the vendor to remove features from under the
user.

> Because that is what your arguments lead to, and that is what the 
> GPLv3 implements.

You haven't really read that bit of dd3 or dd4, have you?

Or the various portions of this thread in which I showed your
assumptions are utterly broken?

> RMS _does not want the Tivo to use a GPLv3 kernel_,

I know you're not stupid, but I can't tell whether you're malicious or
just misinformed.

RMS does not want TiVo (or anyone else) to disrespect users' freedoms,
and installing technical measures to prevent users from adapting the
software to suit their needs and running their modifications is
disrespecting users freedoms.

That he is not opposed to the idea of TiVo using a GPLv3 kernel is
easy to see, if you take the time to read the draft instead of
spreading false assumptions about it:

  this requirement does not apply if neither you nor any third party
  retains the ability to install modified object code on the User
  Product

> Hint: it's not some friendly suggestion of cooperation and working
> together ;)

Hey, wouldn't this be just tit-for-tat? ;-)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
