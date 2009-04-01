Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbZDALkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbZDALkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763324AbZDALkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:40:36 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:39376 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZDALkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mEo+Wd7c+i8DBOe7F4jb2/RwQ42k1FOMAR9jw2K3CvQZ05s7ZNpBYNkuCjgAZgV6mM
         NGOfFDzc3xTmNo1Cuqj3al12lZsXkHuve6WGbJ7/8vrL3xuNWLVJPeS58r5AlE6JO/gw
         mRDJ/hpIoxZnbPksF/d5kpfftwTU9kIjF8oZY=
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Rob Landley <rob@landley.net>, squashfs-devel@lists.sourceforge.net,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [Squashfs-devel] Squashfs 4.0 tools
References: <20090323180808.2c2ef1a7@nehalam>
	<10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com>
	<20090330175524.4e8f802e@nehalam> <200903311431.20494.rob@landley.net>
	<49D2BDE6.7030304@lougher.demon.co.uk>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 01 Apr 2009 13:40:23 +0200
In-Reply-To: <49D2BDE6.7030304@lougher.demon.co.uk> (Phillip Lougher's message of "Wed\, 01 Apr 2009 02\:05\:42 +0100")
Message-ID: <87myb07gbc.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:

Hi,

 Phillip> I have thought about adding this option a couple of times,
 Phillip> but it has always been dropped through lack of time.
 Phillip> Efficiently adding the option isn't as easy as it sounds
 Phillip> because the "fake" device nodes have to somehow be made
 Phillip> available to the recursive directory scan routine that scans
 Phillip> the source directories for files.  Adding a list of fake
 Phillip> device nodes which is scanned on every directory for
 Phillip> potential inclusion in that directory is easy, but not
 Phillip> terribly efficient.

The normal solution for this is fakeroot, which is also what we're
using for mksquashfs in buildroot:

http://git.buildroot.net/buildroot/tree/target/squashfs/squashfsroot.mk

 Phillip> I'll delay the release of the 4.0 tools and see if I can
 Phillip> implement this option in the next day or two.

I would say rather get 4.0 out of the door as soon as possible and
wait with such nice-to-have stuff for later.

-- 
Bye, Peter Korsgaard
