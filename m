Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbXGENYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbXGENYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbXGENYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:24:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53499 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663AbXGENYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:24:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:31:36 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051358.26963.rjw@sisk.pl> <E1I6QOA-0000bq-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6QOA-0000bq-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051531.37532.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 14:24, Miklos Szeredi wrote:
> > Don't you think, however, that it can be modified a little to play well,
> > for example, with the freezer?
> 
> I could stick a couple of try_to_freeze()s into fuse, and that would
> make suspend failure less likely.  But making problems less easy to
> reproduce is not a good thing.

So, how about eliminating them?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
