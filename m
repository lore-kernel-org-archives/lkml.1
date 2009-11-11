Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZKKUTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZKKUTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbZKKUTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:19:50 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:62707 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZKKUTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uNRXiIVGBrdmqTeWHtvJKZG+uluedYWgFuzSWcj9bQeGfBntktJpO5zKewOXDCMFZg
         yitgDOarVXQL3/1OwQzxz4NxP/qAr/8SUGSUciZRNrhnrWCuCbvs9Akeeg95G+4WUJlK
         LXdZvOgrJjBPVedNfQD6j0nLfAat+8kgBG1CU=
MIME-Version: 1.0
In-Reply-To: <200910311944.35922.elendil@planet.nl>
References: <81bfc67a0910310721p21046931o9b512cfd0a8a7acb@mail.gmail.com>
	 <200910311944.35922.elendil@planet.nl>
Date: Wed, 11 Nov 2009 15:19:54 -0500
Message-ID: <81bfc67a0911111219m1efff30cr3186987f9dbb3d4d@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not to be impatient or ungrateful, but has anyone had time to look at
this? will I be able to upgrade to 31.6? will 32.0 work?

On Sat, Oct 31, 2009 at 1:44 PM, Frans Pop <elendil@planet.nl> wrote:
> Adding netdev in CC. Original message + attachments follow.
>
> =========
> so ever since arch rolled out 2.6.31.x I've been having problems with
> my network (again) where I've been losing a large amount of packets
> (just testing with mtr somewhere between 30/50%). first I figured it
> was the same problem as I had in 2.6.30.x (and maybe it is?) but that
> appeared to get fixed. when I started bisecting the bug wasn't
> apparent in 2.6.31.0 but I knew for sure it was in .5 (I couldn't
> remember if I had noticed it again in .3)
>
> I'm attaching the bisection log and a 'good' dmesg output.
>
> c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9 is the first bad commit
>
> I'm not going to pretend to understand why this patch is breaking my
> networking but between bisection and testing it appears to be... I've
> never bisected before and I'm definitely not a kernel hacker (I can
> barely read C).
>
> I should also note that the wireshark dump here
> http://bugzilla.kernel.org/show_bug.cgi?id=13835 is related to this.
> and if it's not the same bug then possibly a new one should be opened.
>
> P.S. I'm not subscribed to the list please CC me
>
> Caleb Cushing
> http://xenoterracide.blogspot.com
>
>



-- 
Caleb Cushing

http://xenoterracide.blogspot.com
