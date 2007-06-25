Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbXFYU21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbXFYU21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXFYU2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:28:18 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:33157 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751261AbXFYU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:28:17 -0400
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 16:28:16 EDT
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Theodore Tso <tytso@mit.edu>, Al Viro <viro@ftp.linux.org.uk>,
       davids@webmaster.com,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: how about mutual compatibility between Linux's GPLv2 and GPLv3?
References: <MDEHLPKNGKAHNMBLJOLKCEKCEMAC.davids@webmaster.com>
	<or4pl0iz15.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070622013417.GT21478@ftp.linux.org.uk>
	<20070622041949.GA15625@thunk.org>
	<orejk4edfl.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070625132853.GH10008@csclub.uwaterloo.ca>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Date: Mon, 25 Jun 2007 16:54:52 -0300
In-Reply-To: <20070625132853.GH10008@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Mon\, 25 Jun 2007 09\:28\:53 -0400")
Message-ID: <orhcov7qsz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 25, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Fri, Jun 22, 2007 at 03:00:30AM -0300, Alexandre Oliva wrote:
>> I was here to dispell the lies that were being spread about GPLv3, the
>> spirit and the goals of the GPL, as far as I understood them.

> Just because someone has a different opinion than you or the FSF does
> not make what they say a lie.

As a general statement, yours is absolutely correct.

However, the situation at hand is quite different AFAICT.  It's about
people repeatedly making statements that misconstrued the intent of a
third party, even after having been drawn attention to this.  AFAICT,
both elements needed to characterize lying are present: deviation from
the truth, and intent to instill the incorrect statements on others as
if they were true.

Now, it might be that those making such statements hadn't fully
realized what they were writing on was on others' intentions, rather
than objective facts or their own opinions, and that they didn't
realize they were misrepresenting those intentions before I brought
this up here.  In this case, if they confirm it, I'll be delighted to
retract my assessment of such behavior as 'lying'.

> Well what the spirit is, is certainly debateable,

If you misunderstand what 'the spirit of a legal text' as something
other than the intent of whoever wrote that document, then yes, it is
debatable.  You may want to take up the alleged inaccuracy to
Wikipedia: http://en.wikipedia.org/wiki/Letter_and_spirit_of_the_law

  When one obeys the letter of the law but not the spirit, he is
  obeying the literal interpretation of the words (the "letter") of
  the law, but not the intent of those who wrote the law. Conversely,
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  when one obeys the spirit of the law but not the letter, he is doing
  what the authors of the law intended, though not adhering to the
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  literal wording.

> Any organization that claims anyone that doesn't agree with its view of
> thw world and its interpretation of some written text is "confused" will
> be treated like all other religigous fanatics, and not listened too.

I suppose it thus follows that people will then take this perception
further and selectively ignore portions of texts written by these
parties.  And then become frustrated and complain when their
conclusions don't match those that are evidently encoded in the
portions that were ignored by them.  And then complain when they're
misunderstanding the text, or when they're characterized as confused,
or however else their selective attention and its misleading
consequences are characterized.

> Intelligent people know better than to listen to such groups.

Ignoring facts that don't fit your ideology, or that support an
ideology you reject, will mislead you, no matter what your fanaticism
or anti-fanaticism is.

> I think I know exactly as much about the GPL now as I did two weeks ago.

Good for you (assuming you're not saying you've refused to learn
anything just because I was the one passing on the knowledge, because,
well, this would be unintelligent too, right? ;-)


Consider this scenario: vendor tivoizes Linux in the device, and
includes the corresponding sources only in a partition that is
theoretically accessible using the shipped kernel, but that nothing in
the software available in the machine will let you get to.  Further,
sources (like everything else on disk) are encrypted, and you can only
decrypt it with hardware crypto that is disabled if the boot loader
doesn't find a correct signature for the boot partition, or maybe the
signature is irrelevant, given that everything on disk is encrypted in
such a way that, if you don't have the keys, you can't update the
kernel properly anyway.  The vendor refuses to give customers other
copies of the sources.  To add insult to the injury, the vendor
configures the computer to set up the encrypted disk partition
containing the sources as a swap device, such that the shared-secret
key used to access that entire filesystem is overwritten upon the
first boot, rendering the entire previous contents of the partition
holding the source code into an incomprehensible stream of bits.

Does anyone think this is permitted by the letter of GPLv2?  Is it in
the spirit of GPLv2?  How are the sources passed on in this way going
to benefit the user or the community?

Is this still desirable by the Linux developers?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
