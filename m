Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbXE3GAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbXE3GAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 02:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbXE3F74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 01:59:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:24524 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXE3F7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 01:59:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VyJURV+c7+2nkVjekbByxU/UAOiPTiCkxwjzHcnamcfq/eZ3SSniTx3ShhgVsyLp6pQTduXlk6hyWP7123W5lzP+/vlRZA+JR3+vo+o8QNrs+iW8ZNkxXtMVjNBUCOg+8JOvWSOsKQDqLrRuCMrlFEmIMvN0JD6Se8fpCUqez6E=
Message-ID: <84144f020705292259o6bfe7613v9a236227ee8f13be@mail.gmail.com>
Date: Wed, 30 May 2007 08:59:54 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
	 <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
	 <Pine.LNX.4.64.0705300654493.5241@jalava.cc.jyu.fi>
	 <84144f020705292254o319f6619m787bf29491c92509@mail.gmail.com>
X-Google-Sender-Auth: 520757c684d5ce46
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> The file at offset 0010000 - 0011348 is overwritten with the byte
> pattern 79 06 00 00.
>
> Do you see anything in the logs or is this a silent corruption? Did
> you see this corruption with 2.6.19 or 2.6.22-rc3?

Btw, please send us a strace log of the mplayer run for 2.6.20.3 and
2.6.21-rc3 so that we can see what it's doing. Furthermore, if you can
bisect this, please treat the bugs as separate for now.
