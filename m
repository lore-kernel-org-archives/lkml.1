Return-Path: <linux-kernel-owner+w=401wt.eu-S2992511AbXDLNJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992511AbXDLNJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992522AbXDLNJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:09:23 -0400
Received: from neon.samage.net ([85.17.153.66]:41319 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992511AbXDLNJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:09:22 -0400
Message-ID: <4232.81.207.0.53.1176383358.squirrel@secure.samage.net>
In-Reply-To: <000401c77cdd$5ef79910$0864a8c0@scs1>
References: <4610D25F.7080005@ceid.upatras.gr>
    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>
    <4616BC09.2080509@tmr.com>
    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
    <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
    <000401c77cdd$5ef79910$0864a8c0@scs1>
Date: Thu, 12 Apr 2007 15:09:18 +0200 (CEST)
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
From: "Indan Zupancic" <indan@nul.nu>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Cc: "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: b76837ecbba1170f708de966edddc2d0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, April 12, 2007 10:34, Tasos Parisinos wrote:
> I didn't have time to read the pdf but i will. As for erasing ram it usually means to also
> scramble it and there are chips that advertise that can do this in 1 cycle. Well reaching the bus
> or ram
> to probe it is another thing. Most die in such chip are also hidden under protective meshes so it
> takes some time.

Those can be peeled off. But the paper I linked to concentrates on other kinds of attacks.

Quote:

"One of the main contributions of this thesis is fault injection attacks done in a semi-invasive
manner which can be used to modify the contents of SRAM and change the state of any
individual transistor inside the chip. That gives almost unlimited capabilities to the attacker in
getting control over the chip operation and abusing the protection mechanism.
Compared to non-invasive attacks, semi-invasive attacks are harder to implement as they
require decapsulation of the chip. However, very much less expensive equipment is needed than
for invasive attacks. These attacks can be performed in a reasonably short period of time. Also
they are scalable to a certain extent, and the skills and knowledge required to perform them can
be easily and quickly acquired. Some of these attacks, such as an exhaustive search for a"

It gives a good overview of all kind of other attacks and defences too. Personally I find the
non-invasive attacks the most interesting. (The pdf is 12 MB, for the low bandwidthers.)


> What you said is true, systems are created and broken, the question is what
> you have to hide and whether the person that wants to break it has the money the will the
> knowledge and the equipment
> to do it. Because if he is to spend a million euro only to create fraud of half a million euro
> then he wont do it.
> That has to do with risk management.

Very true, and the right way to look at it. (Vendors should say "it costs about $X to
break this chip", instead of saying that it's secure, and then not giving guarantees.)


> I understand and i agree, thing is that i dont decide about which parts are given GPL.

No, the kernel licence and others do. But you can't edit the kernel and distribute it without
releasing those modifications under the GPL.


> people think that by hiding implementations (which can be reverse engineered of course)
> will make it more difficult to break. Well i agree with you but... its not in my hands.
> So i will come back with these parts replaced with some of my own

What else is there except the signing and binary loading hooks? Perhaps some caching, but
not much more, is there? I'm a bit baffled about what's kept hidden here, as there doesn't
seem much to hide, except perhaps other, independent "protections", but we weren't talking
about those.

I don't know anything about your company, but I bet the marketing people are more in
favour to keeping it hidden than the security people. I'd ask the legal people for the
kernel parts though.


> And a question
> Can someone provide me with a full list of kernel functions where code is loaded?

Counter questions:

- Why should we give that list if you're not going to release the code you're going to write?
Or in other words, why should we help you?
(But if you're going to open it up, try to find people interested in the same functionality so
you can work together on it. Not me, I'm just a passer-by.)

- That you ask for that list implies that you're not going to audit the whole kernel source
for such functions. That might imply, to some, that your security code isn't as secure as it
should be. People make mistakes, forget things, so on. Both you and people providing a list.
And such mistakes are easiest spotted when more people look at the code. But that's not
possible when the code is hidden. Then only the ones with malicious intents keep looking. So
perhaps it's harder to spot deficiencies in closed source protection code, but it will probably
have more of it too. Your choice, you take the risk.

Greetings,

Indan


