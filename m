Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbYEIQ0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbYEIQ0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756403AbYEIQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:26:28 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:35403 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbYEIQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=arpFiYsSSPG4hYrbNxRFpe69tjI4bSJjl/8Bel/WKjmfa4CMvA4FdfHb1iBOeiNcSEZVLTreMsMpBOpqx9RCix4/IFw+wZ1YcWhmVr/+WFr+fDB9W2UbRo3Eq6vVvbP4wrZMYAWmY/5ijZ4usxWIelL+4JD7H4AC6fOMAOMupnQ=
Message-ID: <5d6222a80805090926v5baeb9ebw6b4dda98548a2933@mail.gmail.com>
Date: Fri, 9 May 2008 13:26:23 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Possible regression? 2.6.26-rc1: T61s failure after suspend/resume
Cc: "Theodore Ts'o" <tytso@mit.edu>, "Glauber Costa" <gcosta@redhat.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805091706390.11688@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1JuCBA-0002NZ-4E@closure.thunk.org>
	 <Pine.LNX.4.64.0805082148060.3994@blonde.site>
	 <5d6222a80805090828j1a1af054y547640c3408bca1b@mail.gmail.com>
	 <Pine.LNX.4.64.0805091706390.11688@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2008 at 1:21 PM, Hugh Dickins <hugh@veritas.com> wrote:
> On Fri, 9 May 2008, Glauber Costa wrote:
>  >
>  > I can't reproduce it neither, and looking at the code over and over
>  > again, see no obvious point for the breakage. I'll try to reproduce it
>  > myself,
>  > to see if I can spot something. But correct me if I'm wrong, this is
>  > all 64-bit machines, right?
>  >
>  > I'm stuck with mostly 32-bit hardware, but will give it a try anyway.
>
>  The machine is 64-bit capable (Core2 Duo), but the kernels I'm running
>  for this are 32-bit, so I doubt that the 64-bitability is relevant.
>  I'd love to see what happens with a 64-bit kernel, but I never get
>  back from suspend with it (and that's not a recent regression).
>  Carlos is also seeing this with a 32-bit kernel (on P4 Xeon with HT).
>
>  Please don't take my git bisection result too seriously: that's where
>  it led when I fudged things around enough, and treated blank screens
>  as manifestations of the problem, which very likely they're not
>  (there's some other bug which makes it very variable how quickly
>  I resume).  And also, I wasn't checking how many cpus came up each
>  time: I wouldn't be surprised if at some points in your series only
>  one would come up, which would then look like a "good" point to me.
>
This is very unlikely. Exactly because I knew problems were likely to
arise in such a delicate thing, I was
extremely careful to make it not an issue. But yeah, ultimately, it can happen.


-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
