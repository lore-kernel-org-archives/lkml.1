Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZHLHpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZHLHpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 03:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZHLHpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 03:45:55 -0400
Received: from mail-yw0-f191.google.com ([209.85.211.191]:52360 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZHLHpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 03:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ipTeQEMKkIKIQLHq9HJJGUyeUcAPM+M0BkIQCjxmSiCPWo4/JOPM1SOBf/ST170U0e
         DSlVE7FDmMPUdOxviPdtlvzrmGLm3HZykn6WXvEz4gn5q/LfNHxgYi3hpIzLoBqVw433
         3aY+vLTR1hIAeoonBNybNaq423kXwVRGA8dT0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908120659001.32131@ask.diku.dk>
References: <43e72e890908111418m47910085k2d0016e2add8914f@mail.gmail.com> 
	<Pine.LNX.4.64.0908120659001.32131@ask.diku.dk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Aug 2009 00:45:35 -0700
Message-ID: <43e72e890908120045s6e94bd5es480bb4ef1a66597c@mail.gmail.com>
Subject: Re: Typedef removal tool
To: Julia Lawall <julia@diku.dk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Nicolas Palix <npalix@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 10:01 PM, Julia Lawall<julia@diku.dk> wrote:
> On Tue, 11 Aug 2009, Luis R. Rodriguez wrote:
>
>> Anyone know if there is a typedef removal tool? When porting drivers
>> this needs to be done quite often.
>>
>> FWIW I've started porting some driver and have come across some tools,
>> or written my own scripts, which have helped. Using spatch to port a
>> driver was such a tool I explored. I think I'll try to put together
>> some info on the driver project wiki for this. typdef removal tool
>> would still be neat.
>
> Nicolas Palix (in CC) did a bit of work on this recently using Coccinelle,
> but the problem is that simply removing the typedef is not enough, one has
> to come up with a name that is within the spirit of the names used in
> Linux, or perhaps recognize that the structure in question already exists
> in a more general form in the kernel an thus the declaration should be
> removed completely.
>
> Someone else made a dedicated tool using a dictionary of the old and new
> names that at least partially addresses these problems.  Nicolas knows who
> that person is.

Sounds like a very proper way to do this.

I wrote something not-so-proper and simple based on Joe's work that
just replaces a specified typedef name with one the user specifies.
Should do it for simple porting where you do not have to prove
correctness and avoid namespace collisions.

  Luis
