Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYCJTjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYCJTjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYCJTjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:39:10 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:58396 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYCJTjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:39:09 -0400
Date: Mon, 10 Mar 2008 20:36:58 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: inotify fixes in stable
Message-ID: <20080310203658.3bdbc27c@mjolnir.drzeus.cx>
In-Reply-To: <20080310160317.GB20775@kroah.com>
References: <20080310091155.02b7fe0e@mjolnir.drzeus.cx>
	<20080310160317.GB20775@kroah.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 09:03:17 -0700
Greg KH <greg@kroah.com> wrote:

> On Mon, Mar 10, 2008 at 09:11:55AM +0100, Pierre Ossman wrote:
> > Hi Greg,
> > 
> > I was hoping that the fixes for bug 7785 "BUG: at fs/inotify.c:172
> > set_dentry_child_flags()" could be added to the stable releases. I'm
> > seeing these quite frequently at customer installations.
> 
> In the future, stable stuff should be sent to the stable@kernel.org
> email address and not directly to me, thanks.
> 

Sorry. :/

> > The relevant commits are d599e36a9ea85432587f4550acc113cd7549d12a and
> > 0d71bd5993b630a989d15adc2562a9ffe41cd26d. Hopefully these do not
> > depend on other updates. Nick would be the expert on that.
> 
> Can you verify that if you apply just those 2 patches to the latest
> 2.6.24.3 kernel release, it fixes the issues for you?
> 

The system is an OpenSuse 10.3 system, so 2.6.22.y would be the interesting one. I'll see if I can get a custom kernel in there (I've been unable to reproduce the problem outside a production environment).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
