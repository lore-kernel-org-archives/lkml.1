Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZCKWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZCKWnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZCKWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:43:23 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:59379 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbZCKWnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r34DL4mkEtmjtBmOEswnc4vFWqEGRpkKnowna5sVqYK67mssExu7byec9dimFHlq0w
         J+YGN6fx1u+wAFi4SOpGh3ihIzvCzRbVG9K3aw5bMs5j+mor1Xg0KF/HlDrWUyM9VYpW
         PmlSd6sOAlNdBVbqeQCuer8ePoinlYOIRof5I=
MIME-Version: 1.0
In-Reply-To: <20090311152000.8a3db19c.akpm@linux-foundation.org>
References: <1228430755-4221-1-git-send-email-felipe.contreras@gmail.com>
	 <5d5443650903111017n9c818b0y2119d06ea84c3abf@mail.gmail.com>
	 <20090311152000.8a3db19c.akpm@linux-foundation.org>
Date: Thu, 12 Mar 2009 00:43:18 +0200
Message-ID: <94a0d4530903111543y4745ade0ofac867ef43e7ab1b@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] omapfb: Fix argument of blank 
	operation.
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trilok Soni <soni.trilok@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-omap@vger.kernel.org,
       felipe.contreras@nokia.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 12:20 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Mar 2009 22:47:41 +0530
> Trilok Soni <soni.trilok@gmail.com> wrote:
>
>> Hi Felipe,
>>
>> On Fri, Dec 5, 2008 at 4:15 AM, Felipe Contreras
>
> I bet he thought we'd forgotten.

You bet correctly :)

>> <felipe.contreras@gmail.com> wrote:
>> > From: Felipe Contreras <felipe.contreras@nokia.com>
>> >
>> > The blank operation should receive FB_BLANK_POWERDOWN, not
>> > VESA_POWERDOWN.
>> >
>>
>> Thanks. Looks good.
>>
>> Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
>>
>
> Unfortunately the changelog didn't give me any hint as to the
> seriousness of the problem which was fixed.  So I queued it for 2.6.30,
> perhaps inappropriately.

I noticed because of another bug in omapfb which required blanking in
order to actually see something (PM stuff?). If user-space tries to
blank the usual way, it wouldn't work.

My guess is that it's not a big issue, in part because nobody has
noticed, but perhaps I'm wrong. I was hoping the fbdev guys would know
better.

-- 
Felipe Contreras
