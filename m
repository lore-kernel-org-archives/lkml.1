Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZC3P00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZC3P00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:26:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZC3P0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:26:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:39547 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZC3P0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=usABGc9vpKPMiNDP61s/cOqlOZ5GlqIxJnikabL8FbnRGqmSNsNX/DMofHVZWUP6Tu
         6DiuFxOP/agRS+T4RC31FS19PRVi3VpvGQUJiiLr7QMF8YH09H5Z8uG9Msjf8Gkjk+i9
         qLeb9k/4sUWNBJEwlJmQzrlOmk46pjeGERI0U=
MIME-Version: 1.0
In-Reply-To: <200903301357.17076.alistair@devzero.co.uk>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
	 <9b1675090903292155q6d221da1q6d19b7bca9cbe4e6@mail.gmail.com>
	 <9b1675090903300033y65dd4bc5td9157de735a76dd9@mail.gmail.com>
	 <200903301357.17076.alistair@devzero.co.uk>
Date: Mon, 30 Mar 2009 09:26:13 -0600
Message-ID: <9b1675090903300826s2ce361e5s1134e13507b0399@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 6:57 AM, Alistair John Strachan
<alistair@devzero.co.uk> wrote:
> On Monday 30 March 2009 08:33:06 Trenton D. Adams wrote:
>>
>> And, if I mark the 2.6.27 one as bad, it just remains on 2.6.27.
>
> Don't worry about the kernel version it generates. Git bisections traverse
> merged branches, including those that weren't rebased before being merged (in
> fact the preferred work flow). I usually add "-bisect" to CONFIG_LOCALVERSION
> so I can isolate my work in progress bisection from system kernels.
>
> You can trust git to involve only relevant commits between your initial "good"
> and "bad" markers; don't add more unless you have to. Sometimes you may need
> to "shift" the bisection midpoint if you encounter build breakage. You should
> be able to find comments Linus made on the subject by searching the LKML
> archive for "git bisect visualize".
>
> --
> Cheers,
> Alistair.
>

Okay, so are you saying that switching back to 2.6.27 is okay, because
the patch that caused this problem may have been created in 2.6.27 (as
a patch to the released version perhaps), not applied to 2.6.28, and
then applied to 2.6.29?
