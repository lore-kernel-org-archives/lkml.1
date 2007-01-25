Return-Path: <linux-kernel-owner+w=401wt.eu-S1030262AbXAYQDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262AbXAYQDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030261AbXAYQDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:03:08 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:4285 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030248AbXAYQDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EsF1ZdCUlIxO4dZqgsZobgAYh5uhhtqSgw76HwAC7EnUHRq7bhTIsWp+UZPqgsX6yjH87kyBV6Q9I4PQbWZKEy8EuxfSwCr3kQfpkDr2SL1G9WdfzTAkcv9ep41BCXEtSHzu3tX0RWRak4gix13vF7Nz4KplD9oFYByyTB+Dv2k=
Message-ID: <7b69d1470701250803q27d742a9o3d04a710d61f3e60@mail.gmail.com>
Date: Thu, 25 Jan 2007 10:03:05 -0600
From: "Scott Preece" <sepreece@gmail.com>
To: "Alessandro Di Marco" <dmr@gmx.it>
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Cc: 7eggert@gmx.de, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, vojtech@suse.cz
In-Reply-To: <878xfrglip.fsf@gmx.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7ELhf-4rC-9@gated-at.bofh.it> <7FKM6-7Gy-1@gated-at.bofh.it>
	 <7G6ME-1g2-11@gated-at.bofh.it> <7GqrZ-6YY-1@gated-at.bofh.it>
	 <7GuFj-5pj-5@gated-at.bofh.it> <7GwQL-h3-7@gated-at.bofh.it>
	 <7GzF3-4L6-47@gated-at.bofh.it> <E1HA3iW-0000kF-VU@be1.lrz>
	 <7b69d1470701250718l58dfbc35rd0b24e5935e32331@mail.gmail.com>
	 <878xfrglip.fsf@gmx.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Alessandro Di Marco <dmr@gmx.it> wrote:
> "Scott Preece" <sepreece@gmail.com> writes:
>
>    On 1/25/07, Bodo Eggert <7eggert@gmx.de> wrote:
>    > Imagine one computer serving two users. Two monitors, two keyboards ...
>    ---
>
>    Good point! Of late I've been working on single-user systems, so it
>    was not at the front of my brain, despite years of building and using
>    multi-user systems.
>
>    It's a point that multi-user systems have struggled with forever (when
>    somebody inserts a CR in the drive mounted in the system box, which user do
>    you pop up a media player for?).
>
> sed s/user X's screensaver/suspend to disk/g <<EOF
>
>    I tend to think it's not a kernel-vs-user-space issue, though. To
>    solve it you need, somewhere, a notion of a "user session" and you
>    need some way to separate system-level issues (like low-battery) from
>    user-level issues (like activiating user X's screensaver).
>
> EOF
>
> Are you sure?
---

Well, a screensaver is associated with a particular user (and screen),
but suspend-to-disk is a system-wide activity that would affect all
the users. So you need to be able to separate those notions in
deciding what actions to take.

scott
