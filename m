Return-Path: <linux-kernel-owner+w=401wt.eu-S1751174AbZGIED5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbZGIED5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbZGIEDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:03:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:49259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZGIEDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:03:47 -0400
Subject: Re: [PATCH 41/44] includecheck fix: include/linux, rfkill.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247081557.9709.16.camel@localhost.localdomain>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247068554.4382.106.camel@ht.satnam>
	 <1247081557.9709.16.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 09:31:59 +0530
Message-Id: <1247112119.2453.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marcel,

On Wed, 2009-07-08 at 12:32 -0700, Marcel Holtmann wrote:
> Hi Jaswinder,
> 
> > fix the following 'make includecheck' warning:
> > 
> >   include/linux/rfkill.h: linux/types.h is included more than once.
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  include/linux/rfkill.h |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
> > index e73e242..2ce2983 100644
> > --- a/include/linux/rfkill.h
> > +++ b/include/linux/rfkill.h
> > @@ -99,7 +99,6 @@ enum rfkill_user_states {
> >  #undef RFKILL_STATE_UNBLOCKED
> >  #undef RFKILL_STATE_HARD_BLOCKED
> >  
> > -#include <linux/types.h>
> >  #include <linux/kernel.h>
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> 
> with the #ifdef __KERNEL__ in between it is kinda weird, but patch seems
> correct.
> 

ACK or Reviewed-by ?

Thanks,
--
JSR

