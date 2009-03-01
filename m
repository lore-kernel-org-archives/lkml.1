Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZCADIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZCADIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 22:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZCADH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 22:07:59 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:44357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZCADH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 22:07:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cnfOWvScKPmOw212IdlC8AYSw4VcQbCceDNzuan1VugpO1LkrUTp15RZyDQ6MBTuyt
         1OaSQQTnoU44svAx/Eutycq3RW4xkCTrx5voYNnQH2chQ7zURwU9u3Y5smbPlG/me7M1
         ib9e0pnYzNa8HPe+89gxEV0Z6pA/0zlyD3I+4=
Date: Sat, 28 Feb 2009 19:07:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Input notifier support
Message-ID: <20090228190644.ZZRA012@mailhub.coreip.homeip.net>
References: <20090225044730.GA9106@july> <87skly16gh.fsf@basil.nowhere.org> <20090228164126.ZZRA012@mailhub.coreip.homeip.net> <9c9fda240902281852n32b41cc7ref61dff7d5c1249f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c9fda240902281852n32b41cc7ref61dff7d5c1249f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 11:52:56AM +0900, Kyungmin Park wrote:
> On Sun, Mar 1, 2009 at 9:42 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Sun, Mar 01, 2009 at 12:34:38AM +0100, Andi Kleen wrote:
> >> Kyungmin Park <kmpark@infradead.org> writes:
> >>
> >> > Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
> >> >
> >> > So add input notifier and then use it at other frameworks such as led.
> >> > Of course, other input device can use this one.
> >> >
> >> > Any commnets are welcome.
> >>
> >> It looks like the perfect interface for a password stealing root kit.
> >>
> >> Yes there are probably other ways to do this, but still this seems to
> >> make it very easy.
> >>
> >
> > We already have good interface for that. That's why you want to limit
> > access to /dev/input/eventX ;) and not make it world-readable.
> >
> 
> Hi Dmitry,
> 
> Could you tell me know which interface you're talking?
> I agreed it's not good idea to pass key code value to drivers. it
> caused security issues.
> 

The interface to steal the root password. One can simply open all input
devices and read all events (if the process has sufficient rights).

-- 
Dmitry
