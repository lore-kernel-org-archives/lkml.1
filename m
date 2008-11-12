Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYKLV5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYKLV5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYKLV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:57:22 -0500
Received: from outbound-mail-22.bluehost.com ([69.89.21.17]:47671 "HELO
	outbound-mail-22.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750953AbYKLV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:57:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Rv0g/4Xh+xq/O7WzkRvpdhX5/Luiq1fsLQ81PkO3UOso5uFeP9WU75CqPbwQrSj0wjCF2JoG2oLYW2m9CzzgajxJAzNyS7d8pdyC4TmFumnYJ5o34RuKsc0GixUOpyvm;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Date: Wed, 12 Nov 2008 13:57:01 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.6-79.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "Mathieu Chouquet-Stringer" <mchouque@free.fr>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081112184236.GR26778@kernel.dk> <200811122237.03882.rjw@sisk.pl>
In-Reply-To: <200811122237.03882.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811121357.02233.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2008 1:37 pm Rafael J. Wysocki wrote:
> On Wednesday, 12 of November 2008, Jens Axboe wrote:
> > On Wed, Nov 12 2008, Jesse Barnes wrote:
> > > On Tuesday, November 11, 2008 7:27 am Mathieu Chouquet-Stringer wrote:
> > > > On Tue, Nov 11, 2008 at 12:15:24AM +0100, Mathieu Chouquet-Stringer 
wrote:
> > > > > This one I guess:
> > > > > http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view
> > > > >
> > > > > Let me give it a shot, I'll keep you posted.
> > > >
> > > > So I compiled the module, rebooted just to have a clean starting
> > > > point, started X then tried to suspend: no go...
> > >
> > > Dave pushed a fix for this (more complete than the one in the patch you
> > > reference), have you tried the kernel from today to see if things work
> > > now?
> >
> > A drm enabled kernel also hangs hard on resume (just see the mouse
> > pointer) here on the x60. Removing drm makes it work just fine. 2.6.27
> > works fine as well.
>
> Is there Intel graphics in there?

Yeah I think so... I wonder if this is another case where a POST conflicted 
with the kernel's restore and caused X to hang...

Jens, does suspend/resume work if you just do it from the console (echo mem > 
/sys/power/state) with i915 loaded?

Jesse

