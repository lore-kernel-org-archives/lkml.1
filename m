Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYFLHqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYFLHqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 03:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYFLHqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 03:46:04 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:24682 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYFLHqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 03:46:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uQxJYek9FGo3qL56CW1P/1lVEJylUfhAVR1BEeriiggVty6x3HsBW9H6sBEH1oAQou
         iVnT7ktWks33YeOLSsLbm/ghJxmqtn09JvuwJT2s6G1aBK1b6k4JZ3g6cRPZDvitf7DO
         NPJpweRtMYAngCsLDItwl+Yx9LkaGo9GaAgDs=
Message-ID: <dd18b0c30806120045r3b0b8dd5h42783aa56eab657b@mail.gmail.com>
Date: Thu, 12 Jun 2008 07:45:58 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <4850C954.60805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
	 <4850794F.3000200@gmail.com>
	 <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com>
	 <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>
	 <4850A2F8.3050404@gmail.com>
	 <dd18b0c30806112222k60e411dfs98e4cc7f64938b5b@mail.gmail.com>
	 <dd18b0c30806112315x70dee219oa6738de3e22d4939@mail.gmail.com>
	 <4850C1AC.4090809@gmail.com>
	 <dd18b0c30806112336ma74115cta1923f7b08dcc2d@mail.gmail.com>
	 <4850C954.60805@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 6:59 AM, Tejun Heo <htejun@gmail.com> wrote:
> Justin Mattock wrote:
>> Yeah, take you're time. Maybe it's easier  to have mplayer or which
>> ever media player wait for the drive. i.g.
>> under OSX, the media player pauses until the drive does it's thing,
>> and then resumes.(but this would be for the suspend aspect)
>> As for the live distro part I'd have to think as well. Let me know
>> what you think.
>
> For apps which know they're accessing cd or dvd (probably using sg
> commands), asking for TUR test after resume could be acceptable but apps
> getting -EIO on read(2) because of intervening suspend/resume cycle is
> just not right.  The problem is that readiness waiting can take quite
> some time and under the current architecture, that can make resume take
> much longer or block IOs to other devices on the same port.  :-(
>
> --
> tejun
>

>From what I could tell it's the whole start, think, move a little,
then start spinning, then slow down, then finally locate it's place,
that the drive
is doing that's causing the timing to be out of sync, with what's left
in the cache/or memory,  I'm wondering if its possible to have the
disk not do the whole cycle that it does once suspend/resume is
activated, just to see.
regards;

-- 
Justin P. Mattock
