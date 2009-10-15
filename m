Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbZJOBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbZJOBfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZJOBfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:35:38 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:40535 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbZJOBfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OTy+bdNVFzmyRHRjxOGeJG6ClX6yiDJewLFpnxGhOb/aL/+UpHsFLjNX88zs95/hia
         Ac+bqz/d23uu3CYHmujR0dr5alQl5uF7xKVIF0buiRHqPQtoGvqTC2tOWTcot7EEsO9y
         I9Yua46ik8JCO7qhIcy9mMWeVLBcUJWl7LxVk=
Subject: Re: [Intel-gfx] [bisected] i915: linux-2.6.32-rc3+ regression
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org
In-Reply-To: <1255563353.15469.0.camel@localhost.localdomain>
References: <20091010213722.051a60dc@mosly>
	 <1255210017.3692.24.camel@maxim-laptop> <200910102347.04579.rjw@sisk.pl>
	 <21d7e9970910101456m277a3c31k3a1add039fcae9d6@mail.gmail.com>
	 <20091011121712.480128d6@mosly>
	 <1255563353.15469.0.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 03:34:55 +0200
Message-Id: <1255570495.5031.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-15 at 01:35 +0200, Maxim Levitsky wrote:
> On Sun, 2009-10-11 at 12:17 +0300, Sergei Trofimovich wrote:
> > On Sun, 11 Oct 2009 07:56:01 +1000
> > Dave Airlie <airlied@gmail.com> wrote:
> > 
> > > Are you running X.org server 1.7 + driver? if so there is a bug in the current
> > > released driver between that combination, the fix is on the intel-gfx
> > > mailing list.
> > > 
> > > The 1.6 X server + same driver doesn't show this problem.
> > Yes, both driver and xorg-server are current -git masters.
> > 
> > Patch http://lists.freedesktop.org/archives/intel-gfx/2009-October/004488.html
> > helped me.
> > 
> > Thanks!
> > 
> > > Dave.
> > > 
> > 
> 
> Works for me too, thanks!
> 
> Best regards,
> 	Maxim Levitsky
> 


One minor issue though, gamma table is still corrupted after X was run
(usplash shows wrong colours)


Best regards,
	Maxim Levitsky

