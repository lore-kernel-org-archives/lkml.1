Return-Path: <linux-kernel-owner+w=401wt.eu-S1750911AbXCVNQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911AbXCVNQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbXCVNQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:16:04 -0400
Received: from neon.samage.net ([83.149.67.130]:47141 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXCVNQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:16:01 -0400
Message-ID: <2990.81.207.0.53.1174569358.squirrel@secure.samage.net>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEBICHAC.davids@webmaster.com>
References: <MDEHLPKNGKAHNMBLJOLKMEBICHAC.davids@webmaster.com>
Date: Thu, 22 Mar 2007 14:15:58 +0100 (CET)
Subject: RE: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel 
     version 2.6.20.1)
From: "Indan Zupancic" <indan@nul.nu>
To: davids@webmaster.com
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.7
X-Scan-Signature: 4b8baa00aa45d625c6ee6c23f4cb0de1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Please don't trim me from the CC list if you're replying to what I've said,
thanks.)

On Thu, March 22, 2007 00:31, David Schwartz wrote:
>> If you can't read protect your kernel, you can't write protect it
>> either.
>
> This is so misleading as to basically be false.

Please elaborate. Short of ROM I don't see how you'd achieve it.
Looks more like a misunderstanding than misleading going on here.


> It is true that any security scheme that can prevent people from taking
> money out of my account can also prevent people from putting money in.
> However, the set of people I allow to put money in my account might include
> people I don't want to be able to take money out.

I wasn't talking about a single security scheme, I was talking about the
possible schemes. Would you trust someone to protect your account if he says
he's able to write protect your account, but not read protect it? And keep
in mind I'm talking about technical abilities, not cases where one access
is chosen to be allowed.

Purposely allowing the one and disallowing the other is a different case.
But there's a difference between opening your door and having a door with
a bad lock.


> As a more concrete counter-example, consider a signed kernel module that I
> wish to publically distribute. I can't stop anyone from reading it. I can
> certainly keep people from changing the copy running on my machine.

Maybe, maybe not. The signature won't stop people from modifying the loaded
kernel, something else has to. And if that 'something' can stop modifications,
it most likely can also read protect a part of kernel RAM too, with little
tweaking. If it can't, I wouldn't trust it to write protect the kernel either.


> Your point is not even valid about keys residing in RAM. There are perfectly
> sensible scenarios in which the same key needs to be in several different
> places, some very secure, some not so. Using a symettric key means that the
> securest use can be compromised by a break of the least-secure use. Consider
> data that is signed by the kernel and verified by a user-space program.

My point is valid, but you seem to confuse it with scenarios where you want to
allow the one and disallow the other, and using that as an argument that my
point isn't valid.

I already said in another email that symmetric key encryption is only as secure
as RSA if each device has its own key, in the case of signed binaries. I'm also
not trying to argue that all asymmetric crypto uses can be replaced with
symmetric ones, in case you wonder.

What I do try to make clear is that for certain cases there are alternatives
which are as secure as RSA, and that a lot apparent weaknesses of that approach
are also present with RSA, and that no matter what you use, you need to have
the same basic security in place for both.

Greetings,

Indan


