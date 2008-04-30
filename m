Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbYD3J2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbYD3J2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYD3J2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:28:00 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:48882 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761013AbYD3J16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:27:58 -0400
Message-ID: <481838A0.2060507@aitel.hist.no>
Date: Wed, 30 Apr 2008 11:15:12 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu> <4816E4FD.5060605@aitel.hist.no> <20080429100934.GB1473@1wt.eu>
In-Reply-To: <20080429100934.GB1473@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Apr 29, 2008 at 11:06:05AM +0200, Helge Hafting wrote:
>   
>>> Well, I accidentally used a freshly installed laptop running mandriva 2008.
>>> I was typing in a terminal inside KDE (I don't know the program name, sort
>>> of an xterm, but with huge borders all around). I made a typo in a word and
>>> typed in a "é" (e acute). Pressing backspace to fix it showed me that I
>>> remove more chars than typed. I tried again. Pressing this letter 5 times,
>>> then 10 times backspace. I removed 5 chars from the prompt. I suspect that
>>> if I had used some chars with wider encoding (eg 4 bytes), I could have
>>> removed as many... Clearly those tools are not ready.
>>>  
>>>       
>> So don't use that particular tool
>>     
>
> It was not my machine, and had you been there, you would have heard me call
> it names !
>   
We all do that, for various reasons...
>   
>> and/or file a bug with the maintainer. :-)
>>     
>
> It's too easy to impose crappy designs to end-users and tell them that if
> that does not work they have to file a bug. There are a minimal set of
> things that must be tested before shipping. Seeing that the default
> terminal emulator in KDE on Mandriva 2008 is configured in UTF-8 and does
> not properly render it simply makes me sick. This is broken by design and
> even distros trying to get it working for years still can't cope with it.
> There must be a reason.
>   
Yeah, ascii-only is a crappy design. :-/ 
I don't know if mandriva is broken by design - I only use debian.
It would not surprise me if some distros  botch utf-8 through negligence.
They are based in english-speaking countries and have their biggest
user bases there - the majority of their customers aren't going to use 
more than
ascii so why should they bother. 

Someone made a "cool" terminal emulator? Transparency and effects?
Distribute it, despite the fact that it won't work in all cases.
Distro contains xterm anyway for those that need a fallback.
Machine owner thinks one terminal emulator is enough and
install the default or cool one only.
>> I have used utf-8 for years - the fact that some editors and some terminal
>> emulators fail is not a problem for me. There are so many that works
>> just fine. There is unicode xterm, and rxvt if you consider xterm too heavy.
>> Both vi and emacs have versions that handle utf-8 competently. You may 
>> have to
>> put in a one-off effort in finding a suitable font for your xterm, if you
>> actually wants to see proper umlauts in all cases. If you don't care about
>> looks, then xterm will display blanks/squares and backspace etc. will 
>> still work.
>>     
>
> I don't care about the *look*. Mutt shows me a question mark when it does
> not know. I care about the *behaviour*. Having backspace go back farther
> than the prompt is not acceptable. Having 80-col lines span over two lines
> is absurd.
>
>   
>> Outside the english-speaking world, userland _was_ completely
>> broken in the day of ascii. And supporting the multiple
>> iso8859-xx encodings was completely broken too, if you ever needed
>> more than one of them.
>>     
>
> yes but you just had unexpected characters. Just like MS-DOS when
> switching from code-page 437 to 850. Aside this, everything worked.
>   
I don't see how wrong characters are better than backspace eating
the prompt or 80-col overflowing when it shouldn't. It is all breakage 
either way.
Stuff break if TERM is set wrong for the terminal in use too, or if the
app in use don't _use_ the TERM variable. This happens too, and you only
notice if the app runs on  a terminal incompatible with TERM=linux.
[...]
>> If you want to know what it is like, knock three vowels or so out of the
>> english alphabet. Consider them not supported. Invent "transcriptions" 
>> if you like.
>>     
>
> amusing comparison :-)
>   
Amusing and accurate. I use Norwegian which has 3 non-ascii vowels. As well
as some accented characters, but they don't crop up in _every other 
sentence_.

>> Lots of people actually bothered - and created various encoding schemes
>> to struggle with until they came up with unicode. English speakers and
>> people _only_ interested in simple tools like tar and ls didn't bother 
>> perhaps.
>>     
>
> You know why we got this encoding ? Simply because it was designed by
> english speakers who did not want to be impacted at all by the transition.
> That way they can still use their old "elm", "cat" and "vi" with no
> hassle and pretend to be UTF-8 ready.
>   
It had to be done in an ascii-compatible way. That way, a userland 
containing
a mix of ascii-only apps,  fully utf-8 supporting apps, and apps with 
partial
utf-8 support will work flawlessly for ascii-only stuff. Like C source and
english language tools. Of course utf-8 only works in the apps 
supporting it,
but utf-8 users keeps fixing this in the apps they need.

Breaking ascii compatibility was not an option, because that means
replacing the entire userland in one operation.  That cannot be done
unless a single authority control everything, and the open source world
isn't like that.

Variable length encoding is necessary, given that:
* Ascii should work as before, i.e. one "char" per ascii character
* One single encoding so a plain text file can contain the symbols of
   any writing system in use. There are way more than 256 symbols.

[...]
>> Such "rules" may work for kernel comments specifically.
>> But linux is used for much more than that, so it now supports utf-8 just 
>> fine.
>> People who have a poperly set up system see no reason why they
>> can't use utf-8 in the kernel too. Consider tools that work. Or fix
>> the few remaining that doesn't work - if you are attached to them.
>>     
>
> No, you're speaking as a desktop user. You upgrade every 6-months. When
> you have several machines, with various OSes, you know that the first
> one which will stuff this crap everywhere will cause even more trouble
> with the other ones. At one moment, you'll have to upgrade everything.
> BTW, do you have an UTF-8 patch for the vt320 and vt510 I use as an
> always-on console on my servers ? Clearly, the system does not have to
> be "properly setup" to behave correctly. A kernel running bash as init
> is a "properly setup system". Displaying wrong things is OK, behaving
> badly is not.
>   
No, I don't have a utf-8 patch for vt320 terminals. Using one is your 
choice.
Either you don't work with utf-8 stuff on it, or you
use intermediate software that translate the utf-8 to something the
terminal can display in an acceptable matter.
>   
>>> I would have loved to see "several different charsets -> ASCII".
>>>  
>>>       
>> And all those that actually used those "different charsets" disagree,
>> or they'd used ascii in the first place too. :-)
>>     
>
> As I said to Adrian, I did not even know there were non-ASCII chars
> in our sources, and found it a bit shocking. Well, maybe I'm just an
> old-timer and I need to stop working with computers :-/
>   
If you _cannot_ accept utf-8, then your computer world will shrink with 
time.
Or you can live with a few things you don't like - most of us have to, 
given that
the computer world has so many people with differing opinions.


Helge Hafting
