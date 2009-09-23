Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbZIWQoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbZIWQoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZIWQoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:44:32 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:51073 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZIWQob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:44:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=fS8tOYNJsLZYzAe7TSLiYEah1ZgeyaDgbDjckMFfZyvVojZEt+0CXLQqT2jFKCX1m8
         2SEyKnZ+mvA7vAWzwBHKBmcUIw+VBOlFEF8sFKQfYv9NVAB8yv0tqMno/kKg/yprYuKd
         auyZV1+9pbsBaLQCqnfd+2IvYs7kKcJOaxeB8=
Date: Wed, 23 Sep 2009 09:44:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: Current git: no keyboard when booting in verbose mode
Message-ID: <20090923164426.GB13435@core.coreip.homeip.net>
References: <6041d2000909221754n2ee1982xe08f938a35358c00@mail.gmail.com> <alpine.LRH.2.00.0909231108100.27145@twin.jikos.cz> <6041d2000909230516g60bad387r3613927ae0d8f5a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6041d2000909230516g60bad387r3613927ae0d8f5a7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:16:02AM -0400, Marc Dionne wrote:
> On Wed, Sep 23, 2009 at 5:09 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> >
> > [ adding some CCs ]
> >
> > On Tue, 22 Sep 2009, Marc Dionne wrote:
> >
> >> I'm having issues with the current kernel in git, and wondering if this
> >> will ring a bell for anyone. The main symptom is that on most boots the
> >> keyboard is not detected - the system gets to the console login prompt
> >> but input is not recognized.  Sometimes (rarely) the keyboard will be ok
> >> at the console, but the keyboard and mouse are non functional once in X.
> >
> > Are both keyboard and mouse in question PS/2?
> 
> No - keyboard is PS/2 but the mouse is USB.
> 
> >> - On a failed boot with no keyboard, this line is missing from dmesg:
> >>     AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> >
> > Could you please provide output from kernel booted with 'i8042.debug' from
> > the failing case?
> 
> Attached are the dmesg output for a successful boot (with "quiet") and
> a failed one.  I see that the i8042.debug output is quite different
> for the 2 cases.
> 

Hmm, nothing obvious jumps at me... Just keyboard not responding at all
in the bad case. Any chance of bisecting? Maybe check before first input
merge and after?

-- 
Dmitry
