Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYCJCD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYCJCD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 22:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbYCJCDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 22:03:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:49412 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYCJCDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 22:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Fawwqo8UwvnXFc/a/kXFaGPWGVO/uLqMxpUx8OLOsIjeOBir01j1XYMO5pp/nyycJzQsRWN9qNQMvGciy3fDnmwiHLH/CXJoQD+3RK2ZIE/syOi4EYsyAeF2SUdCQGpZAC4tqvU38xlyYjYCLSBf+HCaXlvKdE7nW4Hy8CUSdCo=
Message-ID: <a8e1da0803091903i3ea7a54bkea797a43eeae462e@mail.gmail.com>
Date: Mon, 10 Mar 2008 10:03:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] add time_now_after and other macros which compare with jiffies
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080309120133.2d1363e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803080735.06984.hidave.darkstar@gmail.com>
	 <877igd6vqn.fsf@saeurebad.de>
	 <a8e1da0803081654l50fdda44jbbed1d1ed2caf9ae@mail.gmail.com>
	 <20080309095802.70d91c7b@core>
	 <a8e1da0803090344l7f468326r8d3844e20ede08a3@mail.gmail.com>
	 <20080309110808.2249aa3a@core>
	 <20080309120133.2d1363e4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 3:01 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 9 Mar 2008 11:08:08 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>  > > Yes, This has a purpose as well. You will find most of the usage of these
>  > > macros are just compare some value with jiffies after doing some grep.
>  >
>  > That is no reason to add more macros that hide how they do it, or make
>  > jiffies itself invisible to the grep search or variable usage finding
>  > tools (and for tickless that very thing is important)
>
>  We could call them time_is_after_jiffies(), time_is_before_jiffies(), etc.
>
>  Those names are actually better than time_after_now(), etc.
>
>
Andrew, Hannes, Alan,
thanks for your comment, I have send the new time_is_* patch as v3.

Hannes, It's more like your is_past/is_future but looks better when
along with _eq
