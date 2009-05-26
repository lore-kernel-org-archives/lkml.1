Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbZEZXJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbZEZXJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbZEZXJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:09:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59833 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbZEZXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:09:36 -0400
Date: Tue, 26 May 2009 18:14:44 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/38] C/R: core stuff
Message-ID: <20090526231444.GA23602@hallyn.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com> <1242968132-1044-18-git-send-email-adobriyan@gmail.com> <20090526131644.GA20920@hallyn.com> <20090526193503.GB11909@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526193503.GB11909@x200.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> On Tue, May 26, 2009 at 08:16:44AM -0500, Serge E. Hallyn wrote:
> > Honestly, I have great respect for your coding abilities.  And if 'voices
> > from on high' tell us to base upon your code, I'd be fine with that, I
> > have no real problems with what I see on yet another cursory look.  But
> > given the amount of collective time that's been spent developing, reviewing,
> > and testing Oren's set, it wouldn't make any sense to just jump.  So
> > I'd still just like to know how you see this proceeding.
> 
> Yes, please, someone decide on "checkpoint semi-live container" issue.

Well, *I* for one did decide :)  I decided that checkpointing a semi-live
container will not bother the kernel, and so the user gets to decide by
passing a flag into sys_checkpoint() whether he is ok with a checkpoint
if the container was semi-live.

BTW - it looks like your ISP is causing your emails to be flagged as
spam by several servers?  Several people don't seem to be receiving
your patchsets.

-serge
