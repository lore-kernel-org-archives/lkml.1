Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXBPOOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXBPOOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 09:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXBPOOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 09:14:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:21001 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935AbXBPOOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 09:14:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MOjH2Cc6tjm60cqTlfS9otz06pTYtVkKQEtXwOxPad3csxcpveAarGpDeVIpRsfYJioDCRayUhcZJnha9MVYl2dMprTuh/fUfrfq9cnrzDsi2CTI731N7RaBPf2BLbBU0tkEhH0qx1uGc4Y7zhhD9vsj/GujxSX5Xm8L3x60I5s=
Message-ID: <9a8748490702160614u5f596d12yc98c2a5add9da7b3@mail.gmail.com>
Date: Fri, 16 Feb 2007 15:14:16 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Trent Waddington" <trent.waddington@gmail.com>,
       "David Lang" <david.lang@digitalinsight.com>,
       "Scott Preece" <sepreece@gmail.com>,
       "Miguel Ojeda" <maxextreme@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
	 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
	 <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com>
	 <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/02/07, v j <vj.linux@gmail.com> wrote:
> > It's written in black and white, in the license.
>
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.
>
http://www.gnu.org/licenses/gpl.txt
Section 2.b. :
"
    b) You must cause any work that you distribute or publish, that in
    whole or in part contains or is derived from the Program or any
    part thereof, to be licensed as a whole at no charge to all third
    parties under the terms of this License.
"

Linking with kernel exported symbols in a kernel module is by many
people considered creating a work derived from the kernel.


> >  Apart from that,
> > Greg KH has made his opinion clear, and you have said you understand
> > and don't debate that he holds this opinion, and his code is what you
> > said you were linking to (the sysfs/class stuff), so why do you keep
> > saying that "it is not clear".
>
> I know his opinion. I don't debate his opinion. It is his code. I
> choose not to use his code because of the license issue.
>
> > Do you think that, somehow, Linus' opinion trumps Greg KH's opinion on
> > his own code?
>
> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling.

They are not preventing people from using it freely **under the terms
of the GPL**.
If you want 'Free' as in 'I want to take this code and be able to do
whatever I want and never open up my source' then what you want is BSD
licensed code.
The freedoms granted you under the terms of the GPL are different -
they grant you the freedoms to run the code, to modify the code etc
but with a restriction that if you modify/derive from the code and
distribute the result you must also distribute your source.

There's actually nothing new here. The kernel has always[1] been under
a GPL license and anyone who wants to use/modify/distribute it have to
do so under the terms of the GPL.

The kernel modules are a little special.
It's quite obvious that a userspace program that simply uses kernel
provided system calls don't have to use the same license as the kernel
- they simply use services provided by the kernel but they don't
derive from it in any way.
The kernel proper is also quite obvious - if you modify internal code
in the kernel you are obviously modifying, and deriving from, the
kernel so if you distribute such changes you obviously have to
distribute your source as well as per the terms of the GPL.
Where all the controversy is at is kernel *modules*. It is not
entirely clear (in a legal sense) if kernel modules can be said to
derive from the kernel, so it's not entirely clear if they are bound
by the terms of the GPL or not. Court cases are needed to determine
that for certain.  One thing is quite clear however; and that is that
a lot of kernel contributors are of the oppinion that closed source
kernel modules are indeed illegal regardless of EXPORT_SYMBOL /
EXPORT_SYMBOL_GPL.  EXPORT_SYMBOL_GPL was simply introduced as a means
for those kernel developers to make their belief explicit - to be able
to tell the world that "I believe using this symbol makes your code a
derived work of the kernel and thus it has to be GPL", but that's all
it is, a message.  If the courts decide that linking with kernel code
in the form of a module makes the module a derived work, then
EXPORT_SYMBOL and EXPORT_SYMBOL_GPL are completely identical and all
kernel modules must be GPL licensed. However, if the courts decide
that a kernel module is not a derived work, then kernel modules may
only need to be GPL if they use EXPORT_SYMBOL_GPL'ed symbols or they
may not need to be GPL whatever they use - there's no way anyone can
know until there have been court rulings on the matter.

The simple fact is that nothing has actually changed with the
introduction of EXPORT_SYMBOL_GPL except that now those kernel
developers who think anything but GPL'ed modules are illegal can now
express that.


> Especially when these Kernel
> Developers are substituting existing interfaces in the Kernel with
> ones that are NEW and require specific licenses.
>
Depending on who you ask, the requirement for a specific license (GPL)
has always been there, it's just that people got a way to make that a
lot more explicit.



[1] Except the first very few versions that used a licence written by
Linus himself.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
