Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZCXGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZCXGoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZCXGoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:44:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:52910 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZCXGoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:44:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cv993uEF1YbeUrJ1Jcs4RBAWWDVRMqQzzAgSx2rB1PMXV7hgtqFaylXW8BUBsPNyVu
         QSqBqjyFVXE/pz1hQp7VfYkkulLjanGNtEUueXwQQq7+9OtVKX51cTwt0g9dS1JQiBLz
         mSjnVZAs5Ma93M2iEFTR/WRKLllh9nMWilIQE=
MIME-Version: 1.0
In-Reply-To: <20090322233502.GC1114@deepthought>
References: <ff479ab60903210945p51c78f4fgf434d159e880de95@mail.gmail.com> 
	<20090321111520.5fb73195@infradead.org> <49C5BBE8.6010906@zytor.com> 
	<ff479ab60903220222w1d10da15xd446fb4eabfde4d1@mail.gmail.com> 
	<20090322233502.GC1114@deepthought>
Date: Tue, 24 Mar 2009 15:43:50 +0900
Message-ID: <ff479ab60903232343k2448a11dtebe21df6acb24a5f@mail.gmail.com>
Subject: Re: My new fancy font for framebuffer
From: Baybal Ni <nikulinpi@gmail.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 08:35, Ken Moffat <zarniwhoop@ntlworld.com> wrote:
> On Sun, Mar 22, 2009 at 06:22:11PM +0900, Baybal Ni wrote:
>>
>> Yes, but we want it to be bundled in kernel, for me it is the only
>> option for systems with qvga screens or so on. Old fonts were nice
>> only on CRT displays, but on TFTs they are giving too much load on
>> eyes and brain. More clean contoured fonts are effectively cutting it.
>
>  Who are the "we" who want it to be in the kernel ?
>
>  There are _many_ available screen fonts, and I can understand
> people being unhappy with the common existing fonts, particularly
> once messages move beyond English into whatever locale you are using
> (I use my own variant console font [1] to cover most European
> languages with letter forms that I find easy to read), but what
> specific problem does putting terminus in the kernel solve ?
>
>  e.g. are the kernel's boot messages *before* you run 'setfont'
> illegible ?  If so, what is your specific hardware ?
>
>  I've been using only TFTs for a few years, and I don't see any
> significant problems, only questions of preferred letter shapes and
> glyph coverage.  But then, I'm a native English speaker, so I have
> to be willing to accept that a font I find easy to read might not be
> easy for people who do not normally use a latin alphabet.  If that
> applies to you, you need to provide reasons why this belongs in the
> kernel instead of userspace.
>
> ken
>
> [1] sigma-consolefonts - you probably won't like it ;-)
> --
> das eine Mal als Tragödie, das andere Mal als Farce
>

Yes, I don't have a capability to have kbd in my devices, as every bit
is counted on devices with less than 4mb of flash.
My devices are various daps and dffs alike with =< 480x320 screens,
some of them are mochrome. All of them uses linux native fb console.
Thought, it is not a maintream, but still, linux is the only already
solution for things like that.

>That being said, there is no fundamental reason why the BDF and the
>resulting processing can't be included in the kernel.

So, why not just to squeeze the whole kbd into the kernel? =D, or you
want the way how to inject bdf blob compiletime? These way it would
violate the GPL almost the same way as you have already said.

Why you are so unhappy about GPL in GPL? I Think that it is perfectly
ok as long as it goes along with 4 basics of GPL. And it does along
with it.

As I see, current bundled fonts could be already copyright ridden these way.
