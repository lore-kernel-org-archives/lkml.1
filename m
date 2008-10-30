Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYJ3CEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYJ3CEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYJ3CEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:04:09 -0400
Received: from mail.crca.org.au ([67.207.131.56]:33623 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbYJ3CEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:04:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rjw@sisk.pl, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1KvKm8-0000cP-6f@pomaz-ex.szeredi.hu>
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org>
	 <200810292211.49021.rjw@sisk.pl> <1225316715.18786.1.camel@nigel-laptop>
	 <E1KvKm8-0000cP-6f@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Fri, 31 Oct 2008 00:04:02 +1100
Message-Id: <1225371842.8576.6.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2008-10-30 at 00:48 +0100, Miklos Szeredi wrote:
> On Thu, 30 Oct 2008, Nigel Cunningham wrote:
> > Hi.
> > 
> > On Wed, 2008-10-29 at 22:11 +0100, Rafael J. Wysocki wrote:
> > > The current design of the freezer is rather simplistic and I'm not really sure
> > > it's the best one possible.  Perhaps we can redesign the freezer to work
> > > differently and handle the cases like fuse.
> > 
> > Why redo what I've already done? In the full patch, you have the basis
> > of what you're talking about. I haven't seen a failure to freeze fuse or
> > anything else in a year of use.
> 
> Well yeah, your patch handles the straightforward cases.  But it
> doesn't help with the more tricky cases, where one fuse filesystem is
> using another, and as those may become more widespread, this approach
> will fail.

At the moment, yes. But it's not impossible for us to modify the patch
to handle that as well.

Regards,

Nigel

