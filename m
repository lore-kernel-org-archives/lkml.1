Return-Path: <linux-kernel-owner+w=401wt.eu-S935082AbYEUOtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082AbYEUOtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbYEUOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:48:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:39601 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYEUOsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:48:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=URkevIpA2ycHpTDqbZKHKjq+0kUAGI9VUSM2LQM4zcHQPcgPIYpV+d/TW9/rxtkK2I0crtq0KhpfF+9csSUQFVR3nDOWcP7qbNCsENbDl1uijtOe3+le8IbcSO/FQ8viwidqXX6sP5p49SZcz0z80gvqmflT9K2AYLNozRiQC7Y=
Message-ID: <2c0942db0805210748j2429f6f4k4afbd1eebef6d60c@mail.gmail.com>
Date: Wed, 21 May 2008 07:48:51 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: completely lost as to what to do, or where to look.
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30805210733m6d853709xf59331cfed3bfea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
	 <20080520223410.9a8f200d.akpm@linux-foundation.org>
	 <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
	 <20080521075917.GB18352@cs181133002.pp.htv.fi>
	 <dd18b0c30805210733m6d853709xf59331cfed3bfea@mail.gmail.com>
X-Google-Sender-Auth: a8a281a2c00f0649
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 7:33 AM, Justin Mattock <justinmattock@gmail.com> wrote:
>>> Thanks for the help, From what I can remember I noticed this around
>>> 2.6.26-rc1.
[...]
> if I remove
> libdri.so everything starts up as usual so with that in mind since I
> received
> a post about DRI being all F*&^ked up then maybee that is the culprit,
> I think All I really need right now is info on the xserver and the
> kernel.
> What mechanisms are used or files that are responsible for the two too coexist.
> regards;

First, you really need to try the latest kernel from the git
repository (or latest nightly snapshot). The DRI 'mechanisms' you're
asking about were broken in 2.6.26-rc1. They got fixed very, very
recently (past 24 hours). So if you haven't tried the latest kernel
from -git yet, then, respectfully, you're not going to get very far.

Please try the latest kernel first, and then let us know what happens
-- given your description there's a good chance the problem is already
fixed. Also, please report back with the output of `git describe` for
the version you try, so that everyone can see what exact version you
were having trouble with.
