Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbXGWM34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbXGWM34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 08:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbXGWM3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 08:29:43 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:53286 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbXGWM3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 08:29:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 14:31:29 +0200
User-Agent: KMail/1.9.7
Cc: rjw@sisk.pl, nigel@nigel.suspend2.net, stern@rowland.harvard.edu,
       nigel@suspend2.net, jbms@cmu.edu, miltonm@bga.com, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707231408.32051.rjw@sisk.pl> <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1ICwoE-0004q8-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707231431.30372.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 23 Juli 2007 schrieb Miklos Szeredi:
> > The reason is that we want them to "park" in safe places, ie. where there
> > are no locks held etc.  Thus, these safe places need to be chosen somehow
> > and since they are not marked throughout the code, we choose the obvious
> > one. :-)
> 
> Why shouldn't locks be held?
> 
> No locks which are required for suspend must be held, sure.  But
> otherwise holding locks doesn't matter at all.

If you can provide a way to tell them apart, this would work.

	Regards
		Oliver

