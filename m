Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbYD2JSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbYD2JSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbYD2JSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:18:46 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:33038 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbYD2JSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:18:44 -0400
Message-ID: <4816E4FD.5060605@aitel.hist.no>
Date: Tue, 29 Apr 2008 11:06:05 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@kernel.org>,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi> <20080428230524.GK8474@1wt.eu> <48167A07.4000305@kernel.org> <20080429050605.GA27875@1wt.eu> <20080429072911.GA28059@cs181133002.pp.htv.fi> <20080429081423.GD30507@1wt.eu>
In-Reply-To: <20080429081423.GD30507@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Tue, Apr 29, 2008 at 10:29:11AM +0300, Adrian Bunk wrote:
>   
>> On Tue, Apr 29, 2008 at 07:06:05AM +0200, Willy Tarreau wrote:
>>     
>>> On Mon, Apr 28, 2008 at 06:29:43PM -0700, H. Peter Anvin wrote:
>>>       
>>>> Willy Tarreau wrote:
>>>>         
>>>>> Is this really needed Adrian ? I mean, everyone reads iso-8859-1, not
>>>>> everyone reads UTF-8.
>>>>>           
>>>> "Everyone" who speaks a Western European language, perhaps; and even 
>>>> then, mostly because a lot of tools still have a "oh, it's not valid 
>>>> UTF-8, guess iso-8859-1" mode.
>>>>         
>>> Or simply because people have not migrated all their install, or have
>>> explicitly disabled UTF-8 a few hours after starting to use it once
>>> they discovered the mess it caused and the poor support from the
>>> tools :-/
>>>       
>> Non-ancient distributions default to UTF-8 and have tools that handle it 
>> fine.
>>
>> If you had bad experiences in the last millenium you should try again.
>>     
>
> Well, I accidentally used a freshly installed laptop running mandriva 2008.
> I was typing in a terminal inside KDE (I don't know the program name, sort
> of an xterm, but with huge borders all around). I made a typo in a word and
> typed in a "é" (e acute). Pressing backspace to fix it showed me that I
> remove more chars than typed. I tried again. Pressing this letter 5 times,
> then 10 times backspace. I removed 5 chars from the prompt. I suspect that
> if I had used some chars with wider encoding (eg 4 bytes), I could have
> removed as many... Clearly those tools are not ready.
>   
So don't use that particular tool, and/or file a bug with the 
maintainer. :-)
I have used utf-8 for years - the fact that some editors and some terminal
emulators fail is not a problem for me. There are so many that works
just fine. There is unicode xterm, and rxvt if you consider xterm too heavy.
Both vi and emacs have versions that handle utf-8 competently. You may 
have to
put in a one-off effort in finding a suitable font for your xterm, if you
actually wants to see proper umlauts in all cases. If you don't care about
looks, then xterm will display blanks/squares and backspace etc. will 
still work.
> Also, I recently upgraded one machine from 2.6.22 to 2.6.25. Same crappy
> behaviour on the console (with bash). I quickly set the vt.defaults on
> the kernel command line to fix the problem.
>
> At this stage, I'm not even trying to "fix" the problem, as it's
> a philosophical debate and I do not want to enter it. Some people
> consider it normal that we break user-space applications and that
> it's obvious that all useland code has to be replaced to remain
> compatible with "evolutions", and I simply do not support this
> principle.
Outside the english-speaking world, userland _was_ completely
broken in the day of ascii. And supporting the multiple
iso8859-xx encodings was completely broken too, if you ever needed
more than one of them.

Unicode gives userland an opportunity to actually work decently
for the first time. Now, ascii may be fine if C development is all
you ever use the machine for. You can mangle a few names in
comments - some people won't like that at all, some won't care.

But try using the same machine for writing a business letter without
a proper character set. You won't be taken seriously. Or even a non-english
gui app with ascii-only menus.

If you want to know what it is like, knock three vowels or so out of the
english alphabet. Consider them not supported. Invent "transcriptions" 
if you like.
Try writing a letter that way! Or even kernel code with informative 
comments.
See just how much that suck.
>  I just care about having the ability to disable the
> broken behaviour. Most of the problem comes from the variable
> length characters causing wrapping lines and misplaced tabs when
> read in non UTF-8 aware editors and/or terminals.
Consider the alternative - disable the broken behavior by using a
tool that handles UTF-8. There are certainly enough aware apps/tools for
those of us that  need  unicode.

>>> And do we really consider that people's names in *comments* cannot
>>> be converted to pure ASCII ? I'm western european and have always
>>> been against accents in comments (another reason to write comments
>>> in english BTW).
>>>       
>> Accents are very rare in names in the kernel.
>>
>> Most non-ASCII characters are umlauts and there's no sane way to 
>> express them in ASCII (and the vowels without umlaut are pronounced 
>> quite differently and might even make names look very strange).
>>     
>
> Agreed, but it's been done for *years*. I received mails from people
> spelled "jorn" or "jurgen" and they had no trouble using that spelling
> in their names or mail addresses.
>   
It has been done for years because there were no other choice. If you
wanted to work in unix, just forget your own name! Now there is a choice.
Some people still don' care and is fine with "jorn" and such. Some are
pissed off, takes offense, or stick to windows or simply puts unicode
into kernel comments.

If your mailer doesn't support utf-8, chances are you get some mail
from people with very strange looking names too.
>> And that's only within European languages, outside it becomes even 
>> worse.
>>
>>     
>>> Unix and internet have lived without accents for
>>> almost 30 years without anyone really bothering. And now we try to
>>>       
Lots of people actually bothered - and created various encoding schemes
to struggle with until they came up with unicode. English speakers and
people _only_ interested in simple tools like tar and ls didn't bother 
perhaps.
No problem there - the pressure to support more than ascii always was on 
those
wanting to use more than ascii. Now the kernel contains more than ascii,
and if you want to work on it you will have to cope - or succeed in 
patching it out again.
>>> put them everywhere (even in domain names, implying big security
>>> issues) and it causes real annoyances. People's names have not
>>> changed in 30 years, so I guess that the rules used during this
>>> time to ASCII-fy the names are still usable.
>>>       
Such "rules" may work for kernel comments specifically.
But linux is used for much more than that, so it now supports utf-8 just 
fine.
People who have a poperly set up system see no reason why they
can't use utf-8 in the kernel too. Consider tools that work. Or fix
the few remaining that doesn't work - if you are attached to them.
>> The comments in the kernel have been converted to UTF-8 quite some time 
>> ago, what I'm fixing with my patch is just some recent non-UTF-8 stuff 
>> that creeped in.
>>     
>
> Well, if that had already begun, at least you're standardizing.
>
>   
>> And names in comments in the kernel were not pure ASCII since very 
>> early, they were in other charsets.
>>
>> Mostly iso-8859-1, but not all of them.
>>
>> I remember that for one name we first guessed which character it was and 
>> then tried to figure out which charset it was in (no, it was not one 
>> of iso-8859-*).
>>
>> So it was not "ASCII -> UTF-8", it was
>> "several different charsets -> UTF-8".
>>     
>
> I would have loved to see "several different charsets -> ASCII".
>   
And all those that actually used those "different charsets" disagree,
or they'd used ascii in the first place too. :-)

Helge Hafting
