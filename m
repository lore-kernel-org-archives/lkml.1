Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZCAAnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZCAAnW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZCAAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:43:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:59866 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZCAAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:43:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ejl7PaGA9UxzJcpiKDtn5RsuyoFPJUh7KzqTEKT2RpOLnSmEQ7DF+nC+XMuo4ACf57
         r+MmeIGx0TYxdXkiWPq8vMPQmAKvHCoyGYtuvsTVmF9sp7GjNcuTYShqDrD6iCa9xfpU
         f+dewQn3pAEG9NXSkTulLYhdSyuDEBvOXSfMM=
Date: Sat, 28 Feb 2009 16:42:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: [PATCH] Input notifier support
Message-ID: <20090228164126.ZZRA012@mailhub.coreip.homeip.net>
References: <20090225044730.GA9106@july> <87skly16gh.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skly16gh.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 01, 2009 at 12:34:38AM +0100, Andi Kleen wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
> 
> > Some hardware doesn't connected with key button and led. In this case key should be connected with led by software. Of course each application can control it however it's too big burden to application programmer.
> >
> > So add input notifier and then use it at other frameworks such as led.
> > Of course, other input device can use this one.
> >
> > Any commnets are welcome.
> 
> It looks like the perfect interface for a password stealing root kit.
> 
> Yes there are probably other ways to do this, but still this seems to
> make it very easy.
> 

We already have good interface for that. That's why you want to limit
access to /dev/input/eventX ;) and not make it world-readable.

-- 
Dmitry
