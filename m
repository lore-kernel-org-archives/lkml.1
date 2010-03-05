Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab0CEFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:22:22 -0500
Received: from mail-iw0-f175.google.com ([209.85.223.175]:55095 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0CEFWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N1C155ZE5jxsw6iZgs1uk8fSsbovmrP+cMa9JvdBj+wJ5EEbqPiszTrjFk+Emuec7b
         q+CJ15chxy+1rO7kWS4cCgYyzv6SaErDkEbc9xtS0o9UivIZl++nfA8ANjosSBtueIH1
         Ly/XMWzIldxOZKh1WJbw987A5jcQQqcCoqTFs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003042114340.3768@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon>
	 <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>
	 <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>
	 <1267748927.3496.6.camel@nisroch>
	 <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
	 <20100305005617.GA31883@skynet.be>
	 <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>
	 <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain>
	 <21d7e9971003041728u7f7477f4g16805bc1ee235e8f@mail.gmail.com>
	 <alpine.LFD.2.00.1003042114340.3768@localhost.localdomain>
Date: Fri, 5 Mar 2010 15:22:20 +1000
Message-ID: <21d7e9971003042122j4c19ad22odabfa1f4cd90503b@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 3:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 5 Mar 2010, Dave Airlie wrote:
>>
>> wget http://kojipkgs.fedoraproject.org/packages/xorg-x11-drv-nouveau/0.0.16/2.20100218git2964702.fc13/src/xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.src.rpm
>> rebuild + install.
>
> This one doesn't work on F12.
>
> It wants xorg-x11-server-devel > 1.7.99.3-3.
>
> Is there some limited set of rpm's I can get from the f13 archive?

If by limited you mean the whole X server + udev updates that would work,

if not then:
http://people.fedoraproject.org/~airlied/xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.test.src.rpm

That src rpm should be rebuildable on F12, I just removed the requires
on F13 stuff.

Dave.
