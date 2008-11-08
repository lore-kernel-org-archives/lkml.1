Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYKHIUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYKHIUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYKHIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:20:06 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:40247 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYKHIUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:20:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ca1u5PMZfN0RiyQph3g8NatDKN9ZKEeHlMpDdJ8WY/4/1YrLi3QGQRmpCRYLTuHzZD
         yTX+OYfK3IPnk5mjmRDQmin+yDEDzTVaHXWC4/rFgR3myeIqrtEZfk5CuJ1Tp2SriPfG
         gSgxbKIFP8MgElJHgTWpDhPXPWQXl+GWDCVCQ=
Message-ID: <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com>
Date: Sat, 8 Nov 2008 00:20:01 -0800
From: "Justin Mattock" <justinmattock@gmail.com>
To: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org, yakui.zhao@intel.com,
       bugme-daemon@bugzilla.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl, pavel@suse.cz
In-Reply-To: <20081108075008.GA8177@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081106194724.GB15366@ime.usp.br>
	 <20081107014535.GA19201@ime.usp.br>
	 <1226044855.4913f5b7f2f45@webmail.ime.usp.br>
	 <20081108075008.GA8177@ime.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> Hi once again.
>
> On Nov 07 2008, Rogerio Theodoro de Brito wrote:
>> Quoting Rogério Brito <rbrito@ime.usp.br>:
>> > If any further information is needed, please let me know.
>>
>> I just discovered that the "suspend button" is overloaded: it is actually
>> a poweroff button, which would explain the behaviour when the kernel is in
>> suspend to RAM.
>
> I think that I have some more information regarding the suspend/hibernate
> issue: with Ubuntu's 2.6.27 kernel, I can't hibernate my laptop, but with
> vanilla 2.6.28-rc3, I can hibernate (I have not tested it much, but it
> seems to work).
>
> Ubuntu's 2.6.27 kernel was hanging when the hibernation phase was
> occurring.  It just blinked the HD once and nothing else happened. With
> vanilla 2.6.28-rc3, it saves the memory contents to disk and I am able to
> resume.
>
> But seeing the behaviour of this in comparison with Windows Vista, two
> things still stand out:
>
> 1 - pressing the suspend button suspends the machine, but upon a second
>    press, the machine still turns itself off and all work is lost. :-(
>
> 2 - closing the lid, no matter what I program in GNOME's Power Preferences,
>    doesn't even blackens the screen, let alone suspend or hibernate the
>    notebook.
>
> Both of the points above work fine under Windows Vista, but I don't even
> know how to use Windows correctly and I want to use Free Software.
>
> Again, for those that I just included in the carbon copies now, I have
> given extensive information on the bugzilla report, but I can recompile
> kernels, get dumps of debugging information, get dumps under Windows (if
> that helps and if I am instructed how to do that). You name it. I am really
> willing to help as much as possible with all efforts that are possible to
> me.
>
>
> Thanks in advance for any help, Rogério Brito.
>
> --
> Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
> http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
> Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I think you might be experiencing the dreaded black screen upon
wakeup.(after seeing you're quick video);
I was having the same with my macbook pro, when running
radeonhd(haven't tried s2ram yet to see if this resolves the issue).
Although was told it should fix the issue.
Did have the same(black screen of death wakeup); with a dell
inspiron, but then realized my graphics modules weren't configured
properly.
As for radeonhd when I come around to it, I will try s2ram to see, until then
(sorry for the dreaded word) fglrx...
As for the pressing of buttons, the initial pressing of the power button send's
shutdown to the machine for me, but when suspending the system, the power button
wakes the machine up, or closing and opening the lid.


-- 
Justin P. Mattock
