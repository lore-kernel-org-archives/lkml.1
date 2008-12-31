Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYLaIQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYLaIQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYLaIQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:16:44 -0500
Received: from rv-out-0506.google.com ([209.85.198.232]:52419 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYLaIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EI7bLFeDXZUzfwdZ5Cvodzo2pj5TBqQgFr/vk53uGZHjmiYE4MsLzJQnATw/VrmJJ0
         OPSptvggnkRInDtNay89BliDlDxh6ZrkBa7SU2WrTwcCIDhqa+8g1S6LI2Xb3jC/BW1n
         iqe3TCiLy7xiAn8/Q1PSRPb/jUzr7BQ8a2NNY=
Message-ID: <9bd6b5360812310016k7a75bf8fpbb49de8d9799cbdf@mail.gmail.com>
Date: Wed, 31 Dec 2008 16:16:41 +0800
From: sniper <s3c24xx@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Cc: tux3@tux3.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200812310000.55256.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812301935.49303.phillips@phunq.net>
	 <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com>
	 <200812310000.55256.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 4:00 PM, Daniel Phillips <phillips@phunq.net> wrote:
> On Tuesday 30 December 2008 23:34, sniper wrote:
>> Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
>> but I still can't debug it with gdb. Anyone gives me suggestion?
>
> You just have to give a "cont" command a bunch of times and you will
Yes, it works now,

Thanks.
> eventually get to a command prompt.  The reason for this is, uml uses
> the segfault interrupt as part of its machine simulation, and there
> is no exsiting way for uml and gdb to communicate in such a way that
> uml can recognize that the interrupt came from its own code and filter
> it.
>
> Jeff Dike is the expert on this, and Daniel Jacobowitz is the expert
> on the gdb side.  Fixing this would be a big effort, getting two complex
> systems to cooperate better, with nontrivial API issues to solve.  But
> UML is such a wonderful kernel development tool that it might be worth
> the effort.
>
> In the mean time, you could just tell gdb to mask off all segfaults,
> but would be kind of problematic for debugging.
>
> Regards,
>
> Daniel
>
