Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbYDOJVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbYDOJVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYDOJU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:20:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35886 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYDOJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:20:55 -0400
Date: Tue, 15 Apr 2008 12:20:52 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] smb.h: uses struct timespec but didn't include linux/time.h
In-Reply-To: <20080415021057.9bdff72f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804151212310.17123@wrl-59.cs.helsinki.fi>
References: <Pine.LNX.4.64.0804151202390.17123@wrl-59.cs.helsinki.fi>
 <20080415021057.9bdff72f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Andrew Morton wrote:

> On Tue, 15 Apr 2008 12:04:04 +0300 (EEST) "Ilpo J__rvinen" <ilpo.jarvinen@helsinki.fi> wrote:
> 
> > 
> > Signed-off-by: Ilpo J__rvinen <ilpo.jarvinen@helsinki.fi>
> > ---
> >  include/linux/smb.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/smb.h b/include/linux/smb.h
> > index f098dff..caa43b2 100644
> > --- a/include/linux/smb.h
> > +++ b/include/linux/smb.h
> > @@ -11,6 +11,7 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/magic.h>
> > +#include <linux/time.h>
> >  
> >  enum smb_protocol { 
> >  	SMB_PROTOCOL_NONE, 
> 
> Did this actually cause a compilation error?

No and yes, none I know of in mainline but with my uninlining tool, if 
that counts :-), it did until I work-around the number of compilation 
failures I got if I just include a single header file to a uninlined.c by 
taking an existing compilation unit's list of headers (and hoping for the 
best), which worked most of time (this case include). ...I'm not sure 
should they all be fixed or not (not to speak of how). Finding most of 
them seems relatively easy to automate by include alone + compile.


-- 
 i.
