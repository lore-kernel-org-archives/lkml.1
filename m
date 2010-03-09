Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0CIKPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:15:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:33811 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab0CIKPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:15:43 -0500
Date: Tue, 9 Mar 2010 11:15:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: mickib1@gmail.com, chatty@enac.fr, peterhuewe@gmx.de, micki@n-trig.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] HID: N-trig MTM Driver fix And cleanup patch 6
In-Reply-To: <4B95A24D.2090903@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1003091114430.17799@pobox.suse.cz>
References: <1268082827-2680-1-git-send-email-micki@n-trig.com> <1268082827-2680-2-git-send-email-micki@n-trig.com> <1268082827-2680-3-git-send-email-micki@n-trig.com> <1268082827-2680-4-git-send-email-micki@n-trig.com> <1268082827-2680-5-git-send-email-micki@n-trig.com>
 <1268082827-2680-6-git-send-email-micki@n-trig.com> <4B95A24D.2090903@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Rafi Rubin wrote:

> >   static int __init ntrig_init(void)
> >   {
> > +	info("N-trig Driver Version 1.6\n");
> 
> Perhaps you mean:
> MODULE_VERSION("1.06");

I'd rather remove all the MODULE_VERSION stuff altogether. git is much 
better tracking revisions, once the driver gets merged.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
