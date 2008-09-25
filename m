Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbYIYBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbYIYBES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYIYBEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 21:04:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:56940 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYIYBEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 21:04:06 -0400
Date: Wed, 24 Sep 2008 18:03:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: "Greg KH" <gregkh@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-Id: <20080924180316.d6f9f85c.randy.dunlap@oracle.com>
In-Reply-To: <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
References: <20080924230054.GA27730@suse.de>
	<f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 19:39:42 -0400 Parag Warudkar wrote:

> On Wed, Sep 24, 2008 at 7:00 PM, Greg KH <gregkh@suse.de> wrote:
> > So, does this all look good to everyone?  Any questions/issues?
> >
> 
> I sure hope this does not end up like EXPERIMENTAL although it
> essentially does duplicate the intent of EXPERIMENTAL.
> (In other words - drivers live there for ever in staging mode, we
> print warnings and generally nobody cares about the problem since the
> kernel is tainted.)
> 
> That aside please at least substitute the word CRAP with something
> better - like TAINT_NON_PRODUCTION or TAINT_UNRELIABLE or
> TAINT_WORK_IN_PROGRESS or TAINT_EXPERIMENTAL . Arguably
> TAINT_EXPERIMENTAL could also be used for known broken
> CONFIG_EXPERIMENTAL items. It might also be better to change the
> staging directory name to non-production or experimental - but that's
> just my preference.
> 
> Also, I suppose it would be useful for Production machines to have a
> kernel command line flag or something to say don't load staging
> modules - for instance to prevent against automatic loading on drivers
> from staging directory to support some oddball device etc.
> 
> Thinking more about it - could this whole thing not be achieved by
> setting per module experimental flag and refusing to insmod'ing
> experimental modules if -f was not specified. I believe force loading
> also taints the kernel? All drivers intended for staging can set that
> flag  - this way we don't need another TAINT flag and there is no need
> for the directory name hack.

Thanks.  I agree with Parag's comments.

Looks like overkill/duplication.

---
~Randy
