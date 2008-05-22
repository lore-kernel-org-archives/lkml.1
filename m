Return-Path: <linux-kernel-owner+w=401wt.eu-S937313AbYEVBYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937313AbYEVBYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765084AbYEVBXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:23:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:63010 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764582AbYEVBXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ui6dnxWA54gFJSUVxZP8vUQsgy1L9PIkPq0bypmgXJBUXr/c0uirSdgazi7m6RE+M5mFSCKGQuargsu6wJKRHZG9uP0z9QEkFsiZtsTjBLrMH/Tzz5ERR0eJdNGNWAG1r3JvHTMv5ojBZsM/ft5txzxnDGx7tyj90cU7T86ryAs=
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Paul Mackerras <paulus@samba.org>,
       Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de>
	 <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org>
	 <18484.44691.477859.334222@cargo.ozlabs.ibm.com>
	 <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
	 <20080522005657.GU28946@ZenIV.linux.org.uk>
	 <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 21 May 2008 18:23:39 -0700
Message-Id: <1211419419.6908.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 18:20 -0700, Linus Torvalds wrote:
> 
> On Thu, 22 May 2008, Al Viro wrote:
> > 
> > Eh?  git mv include/asm-$i arch/$i/include/asm, then?
> 
> Yeah, sorry, I dropped an "include/" there. 
> 
> > Nice, but... how do you pull what's currently asm-generic/foo.h from what's
> > currently asm-bar/foo.h?  #include_next is _ugly_...
> 
> I was actually going to suggest #include_next, yes. But if people hate it, 
> we can certainly just keep the current <asm-generic/xyz.h> approach.
> 

What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>

Harvey

