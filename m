Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbXEMQdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbXEMQdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 12:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934061AbXEMQdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 12:33:11 -0400
Received: from smtp.linux-foundation.org ([207.189.120.12]:44674 "EHLO
	smtp.osdl.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759159AbXEMQdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 12:33:09 -0400
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 12:33:09 EDT
Date: Sun, 13 May 2007 09:22:27 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Vladimir Pouzanov" <farcaller@gmail.com>, "Len Brown" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ACPI Power Down is broken in 2.6.21.1
Message-ID: <20070513092227.6d87e60d@freepuppy>
In-Reply-To: <6bffcb0e0705130729n2c47f0f4h6791ac4b74b9bb62@mail.gmail.com>
References: <loom.20070508T175303-27@post.gmane.org>
	<6bffcb0e0705130729n2c47f0f4h6791ac4b74b9bb62@mail.gmail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 16:29:25 +0200
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> Hi Vladimir,
> 
> [adding Len and ACPI gurus to CC]
> 
> On 08/05/07, Vladimir Pouzanov <farcaller@gmail.com> wrote:
> > Hi all,
> >
> > I have got a problem with Asus F3T notebook and 2.6.21.1 kernel. When I
> > perform powerdown (with user-space app or alt+sysrq+o) I get "Power Down."
> > message, but the notebook doesn't turn off. Everything is ok on 2.6.20.
> >
> > There seem to be no changes in acpi/sleep/poweroff.c so I don't know where
> > should I start looking for a bug.
> >
> > F3T is based on Thrion64 X2 CPU (I'm running it in x86 mode with SMP and
> > PREEMPT).
> >
> > Sincerely,
> > Vladimir "Farcaller" Pouzanov
> > http://hackndev.com
> >
> 
> I added this bug to the list of known regressions.
> (http://kernelnewbies.org/known_regressions)
> 
> Regards,
> Michal
> 

Is the network still connected? Maybe there is a wake on lan
problem with the network device.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
