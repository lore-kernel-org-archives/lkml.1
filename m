Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYKIEjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYKIEjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 23:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYKIEjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 23:39:08 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:50620 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbYKIEjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 23:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=an/ASIReKrkXgxFVLN0xnHy5HhA+yRRgT3PhCDx5gTlpUCivbL+YlGOSqYRIvbt/kH
         RsKjzbYwRc/x2Pkko/vkFq525o4ijclzJrL6IF6jlp7ReR0N+agLDbNXZoLNoAcHODl4
         oricVdK0JZ91xAJOMJpGRlxVyrydkYsLdgv7k=
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br>
Message-Id: <3DCE2017-408C-45E2-8E0D-3A474E8645F6@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: =?utf-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20081109024514.GA11744@ime.usp.br>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (5F136)
Mime-Version: 1.0 (iPhone Mail 5F136)
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends, but does not wakes up
Date: Sat, 8 Nov 2008 20:38:26 -0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "yakui.zhao@intel.com" <yakui.zhao@intel.com>,
       Bugreport <bugme-daemon@bugzilla.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Rafael Wysocki <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       "rbrito@ime.usp.br" <rbrito@ime.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appologize if this is quite brief
(sending from phone);
For the long delay try comment #2
Of:
http://bugzilla.kernel.org/show_bug.cgi?id=11220
Keep in mind msi.c might have been changed since then, so it might not  
work

justin P. Mattock



On Nov 8, 2008, at 6:45 PM, Rogério Brito <rbrito@ime.usp.br> wrote:

> Hi, Justin and others.
>
> On Nov 08 2008, Justin Mattock wrote:
>> On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> 
>>  wrote:
>>> I think that I have some more information regarding the suspend/ 
>>> hibernate
>>> issue: with Ubuntu's 2.6.27 kernel, I can't hibernate my laptop,  
>>> but with
>>> vanilla 2.6.28-rc3, I can hibernate (I have not tested it much,  
>>> but it
>>> seems to work).
>
> Just some extra information here: while I can hibernate with vanilla
> 2.6.28-rc3, upon resuming, it takes *minutes* (I don't know how many
> minutes, but probably something like 5 minutes or so!) for the  
> desktop to
> have any effect (despite the fact that I can move the mouse without  
> any
> problems).
>
> A new reboot is *much* faster than what I get with hibernate.
>
> I can film that if desired.
>
>>> But seeing the behaviour of this in comparison with Windows Vista,  
>>> two
>>> things still stand out:
>>>
>>> 1 - pressing the suspend button suspends the machine, but upon a  
>>> second
>>>   press, the machine still turns itself off and all work is  
>>> lost. :-(
>
> This problem still persists.
>
>>> 2 - closing the lid, no matter what I program in GNOME's Power  
>>> Preferences,
>>>   doesn't even blackens the screen, let alone suspend or hibernate  
>>> the
>>>   notebook.
>
> A correction here: when I close the lid, the laptop suspends. I can  
> try to
> see if it hibernates.
>
>>> Again, for those that I just included in the carbon copies now, I  
>>> have
>>> given extensive information on the bugzilla report, but I can  
>>> recompile
>>> kernels, get dumps of debugging information, get dumps under  
>>> Windows (if
>>> that helps and if I am instructed how to do that). You name it. I  
>>> am really
>>> willing to help as much as possible with all efforts that are  
>>> possible to
>>> me.
>
> Again, I am willing to get any debugging information or anything  
> that is
> asked me. I am testing things and I still don't have any production  
> data on
> that notebook.
>
> BTW, I installed Windows Vista with a dual boot. I'm feeling tainted
> now. :-(
>
>> I think you might be experiencing the dreaded black screen upon
>> wakeup.(after seeing you're quick video);
>
> Nice that the video proved useful to demonstrate the issue. I can take
> another video to show the current behaviour with 2.6.28-rc3.
>
>> I was having the same with my macbook pro, when running
>> radeonhd(haven't tried s2ram yet to see if this resolves the issue).
>> Although was told it should fix the issue.
>
> Right. Just for further information, this notebook here has a plain  
> ICH8
> chipset. The only thing that I think that is not from intel is the  
> gigabit
> ethernet, which is a Realtek one (it seems that the r8169 driver is  
> loaded,
> but I still have not tested wired connections).
>
>> Did have the same(black screen of death wakeup); with a dell
>> inspiron, but then realized my graphics modules weren't configured
>> properly.
>
> Weird. I have a Dell Latitude D520 here (which I'm using for this e- 
> mail)
> and everything that I tried works fine (suspend, wifi, hibernation  
> and even
> the compiz stuff---which I promptly disable). It has a broadcom  
> ethernet
> that seems to use the b44 driver, but I have also not used the wired
> connection here.
>
> I'm streaming audio via daap to this notebook from a Kurobox  
> (powerpc box)
> with kernel 2.6.27 kernel (and my patches that were included in
> 2.6.28-rc3).
>
>> As for the pressing of buttons, the initial pressing of the power  
>> button send's
>> shutdown to the machine for me, but when suspending the system, the  
>> power button
>> wakes the machine up, or closing and opening the lid.
>
> For me, nothing like this works. :-( I can open the lid and it still  
> stays
> sleeping. Pressing the suspend (poweron/poweroff?) button while  
> suspended
> only turns off the machine. :-(
>
>
> Thanks again for any feedback, Rogério Brito.
>
> -- 
> Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAE 
> B8
> http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
> Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
