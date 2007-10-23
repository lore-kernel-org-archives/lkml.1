Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXJWFxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXJWFxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbXJWFxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:53:36 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:49383 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXJWFxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:53:35 -0400
Message-ID: <471D8C54.4050907@debian.org>
Date: Tue, 23 Oct 2007 07:53:24 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Thomas Fricaccia <thomas_fricacci@yahoo.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       LSM ML <linux-security-module@vger.kernel.org>,
       Crispin Cowan <crispin@crispincowan.com>
Subject: Re: LSM conversion to static interface
References: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
In-Reply-To: <200710221700.l9MH0klg006152@sapphire.spiritone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Fricaccia wrote:
> Some well-respected contributors have taken exception my amplification
> of Crispin Cowan's point about the patch that closes LSM.
> 
> Crispin Cowan <crispin@crispincowan.com> wrote:
>>     * It prevents enterprise users, and in fact anyone who isn't
>>       comfortable compiling their own kernel, from ever trying out any
>>       security module that their distro vendor of choice did not ship.
> 
> I extended this point by observing that regulatory laws make it difficult
> for enterprise customers to compile their own kernels, mentioning one
> of the more invasive statutes, Sarbanes-Oxley.
> 
> In reply, "Alan Cox" <alan@lxorguk.ukuu.org.uk> writes:
>> Crispin at least is providing genuine discussion points. Sarbox has
>> nothing to say on "using vendor linux kernels".
> 
> And just previously, "Greg KH" <greg@kroah.com> had written:
>> Since when does Sarbanes-Oxley decree that a company must use a
>> "standard kernel"?  And just exactly what defines such "standard
>> kernel"?  Can you point out where in that bill it requires such a
>> thing?
> 
> I was actually talking about the *effects* of regulatory law, rather
> than the wording in the text of the statutes.  The misunderstanding
> could be partially my fault, as my exact words were 
> 
>    As Sarbanes-Oxley and other regulatory laws require these
>    customers to use "standard kernels" ....
> 
> which may not have been as unambiguously clear as I intended.
> 
> But as long as we're here, let me elaborate on the point I tried to make.
> 
> SOX and other laws require enterprise customers to keep specified
> controls on their internal processing procedures, and keep documentation
> that can be audited to prove compliance.  The auditing requirements
> are extensive and detailed, and certainly include the kernel of an
> operating system used to process business and/or financial transactions.
> 
> It is within this framework that enterprise customers conclude something
> like (and this is vernacular, not the language within the statutes) "if
> we use any kernel other than that supplied by our distributor, the
> SOX auditing paperwork will be a nightmare."  (I've actually heard
> statements similar to this, and so believe that it is an accurate
> portrayal of the perception of the effects of regulatory law.  I'm not
> a lawyer.)
> 
> As I said at the beginning, I meant to amplify Crispin's observation
> that enterprise customers are reluctant to compile their own kernels
> with the additional observation that the complexities of regulatory
> law create obstacles that are significant contributors to that reluctance.
> 
> I'll not belabor the unfortunate non sequitur further.  You can find
> plenty of documentation of auditing requirements with by Googling
> combinations of "Sarbanes-Oxley," "operating system integrity", etc.
> This is a big-business topic of wide concern.

What do technical and regulatory differences have "driver/LSM module" that
is build-in and one that is modular?
It seems to me silly to find difference.  A kernel with a new kernel module
is a new kernel.

ciao
	cate
