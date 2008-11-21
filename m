Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYKUJA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYKUJA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYKUJAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:00:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:8365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYKUJAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:00:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=dbpkh1NXEk8O5VRdCi7wjLg3U3+oHa/Z0Tlw7dK7IjIZumgdZKwocez7YDnFey+q7e
         ecsCITr1H4OjAVFXzRYWJIci5CbhwNRJ4vyXBDgH3kEFmXZYvHPtGELYoO90pwuT5lvU
         qq8ugKgzlV0DVPUa+e3Nwqdq1fdqop040x380=
Date: Fri, 21 Nov 2008 09:00:45 +0000
From: Matt Fleming <mjf@gentoo.org>
To: Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Jim Radford <radford@galvanix.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/3] sh: dynamic ftrace support.
Message-ID: <20081121090044.GA635@console-pimps.org>
References: <20081120203415.251344054@goodmis.org> <20081120203551.633484431@goodmis.org> <20081121074428.GC28447@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121074428.GC28447@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 04:44:29PM +0900, Paul Mundt wrote:
> On Thu, Nov 20, 2008 at 03:34:16PM -0500, Steven Rostedt wrote:
> > +} elsif ($arch eq "sh") {
> > +    $section_regex = "Disassembly of section\\s+(\\S+):";
> > +    $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
> > +    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
> > +    $type = ".long";
> > +
> > +    # force flags for this arch
> > +    $ld .= " -m shlelf_linux";
> > +    $objcopy .= " -O elf32-sh-linux";
> > +    $cc .= " -m32";
> > +
> 
> Note that if the $alignment changes are in this version, you will also
> need to add an $alignment = 2; for sh. That was in Matt's original patch,
> but I stripped the alignment line out in the commit given that it was not
> yet present in the mainline version of the script.

I've sent a patch to steven for his tip/devel branch that adds this line.

