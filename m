Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYHTXVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYHTXVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYHTXVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:21:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:58310 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYHTXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=kqIDgfr4/vSJtSWoTdz5RbFyWB2IrAOfIg0UxPvUAqKHIQuH7zTjLpxer92Dj0+xLe
         ax5c/8RD1ppFMdpYCU5jRfPT+8tR3j4zAXhTNWuzn8vIyp9SYcqNrW8vzZwAoErkZlWv
         tt/UrtdmZL6h/hvUUoxeNS1yn9J7+GwEXp8uM=
References: <200808210045.42693.rjw@sisk.pl> <alpine.LFD.1.10.0808201548300.3487@nehalem.linux-foundation.org> <200808210058.06515.rjw@sisk.pl> <alpine.LFD.1.10.0808201557430.3487@nehalem.linux-foundation.org>
Message-Id: <43861540-892A-4C87-BDEB-1858E73D66E8@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808201557430.3487@nehalem.linux-foundation.org>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5C1)
Mime-Version: 1.0 (iPhone Mail 5C1)
Subject: Re: [OT] 'git pull' from Linus' tree doesn't work for me any more
Date: Wed, 20 Aug 2008 16:21:38 -0700
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like I need to upgrade
My git. At the moment using
1.5.6.3.

justin P. Mattock



On Aug 20, 2008, at 4:07 PM, Linus Torvalds <torvalds@linux-foundation.org 
 > wrote:

>
>
> On Thu, 21 Aug 2008, Rafael J. Wysocki wrote:
>>
>> Well, it hasn't been working for a couple of hours now ...
>
> Hmm. I just tested it myself, and it worked fine for me to just update
> another machine by pulling from git.kernel.org.
>
> What version of git do you have? One thing that changed recently is  
> that
> at least some kernel.org git binaries got updated to 1.6.0, and if you
> have a really ancient version of git (Debian 'stable' aka 'rubbish'  
> ships
> with something two years old), you'd better upgrade.
>
> From the 1.6.0 announcement:
>
>  GIT v1.6.0 Release Notes
>  ========================
>
>  User visible changes
>  --------------------
>
>  With the default Makefile settings, most of the programs are now
>  installed outside your $PATH, except for "git", "gitk" and
>  some server side programs that need to be accessible for technical
>  reasons.  Invoking a git subcommand as "git-xyzzy" from the command
>  line has been deprecated since early 2006 (and officially announced  
> in
>  1.5.4 release notes); use of them from your scripts after adding
>  output from "git --exec-path" to the $PATH is still supported in this
>  release, but users are again strongly encouraged to adjust their
>  scripts to use "git xyzzy" form, as we will stop installing
>  "git-xyzzy" hardlinks for built-in commands in later releases.
>
>  An earlier change to page "git status" output was overwhelmingly  
> unpopular
>  and has been reverted.
>
>  Source changes needed for porting to MinGW environment are now all  
> in the
>  main git.git codebase.
>
>  By default, packfiles created with this version uses delta-base- 
> offset
>  encoding introduced in v1.4.4.  Pack idx files are using version 2  
> that
>  allows larger packs and added robustness thanks to its CRC checking,
>  introduced in v1.5.2 and v1.4.4.5.  If you want to keep your  
> repositories
>  backwards compatible past these versions, set  
> repack.useDeltaBaseOffset
>  to false or pack.indexVersion to 1, respectively.
>
> and no, I am not at all interested in helping Debian continue to ship
> git versions almost two years old, and much inferior to modern  
> versions.
> So I'm not going to set the flag that makes it work with old gits.
>
>          Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
