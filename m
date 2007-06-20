Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbXFTSZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbXFTSZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbXFTSZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:25:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:26436 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbXFTSZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:25:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y7hDbRP6Yv9lWsGMLuEGZGmXkBXRz+ekmDWue9JnjRqmFSUOORwU/HaS4h842GjSXP9jveI3IqRwA5cN/qCbNcuewWIVIu6XOCMpGP5TzUqXr8MBX9RSnqP5hIKaCdBRhvWlVWKd3gExC3m5V2AiL2QzGpsgvqOL25W+hU4kl9E=
Message-ID: <787b0d920706201125g2368a4e1i2d115b0b2d5399e5@mail.gmail.com>
Date: Wed, 20 Jun 2007 14:25:20 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: JIT emulator needs
Cc: "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <467957CB.8020704@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <20070619150824.GH11781@holomorphy.com>
	 <787b0d920706192016l660dd5b0mbf300581db81ac62@mail.gmail.com>
	 <20070620160116.GI6909@holomorphy.com> <467957CB.8020704@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, H. Peter Anvin <hpa@zytor.com> wrote:
> William Lee Irwin III wrote:

> > I presumed an ELF note or extended filesystem attributes were already
> > in place for this sort of affair. It may be that the model implemented
> > is so restrictive that users are forbidden to create new executables,
> > in which case using a different model is certainly in order. Otherwise
> > the ELF note or attributes need to be implemented.
>
> Another thing to keep in mind, since we're talking about security
> policies in the first place, is that anything like this *MUST* be
> "opt-in" on the part of the security policy, because what we're talking
> about is circumventing an explicit security policy just based on a
> user-provided binary saying, in effect, "don't worry, I know what I'm
> doing."
>
> Changing the meaning of an established explicit security policy is not
> acceptable.

Not in this case. If an attacker can CHANGE THE BINARY then
it's already game over.

Putting this into the security policy was an error born of
lazyness to begin with. Abuse of the security mechanism
was easier than hacking the toolchain, ELF loader, etc.

Either a binary needs self-modification, or it doesn't. This is
determined by the author of the code. If you don't trust an
executable that needs this ability, then you simply can not
run it in a useful way.
