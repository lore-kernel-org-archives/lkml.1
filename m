Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbXGQFmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbXGQFmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 01:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXGQFm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 01:42:26 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35926 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbXGQFmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 01:42:25 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: Hibernating To Swap Considered Harmful
Date: Tue, 17 Jul 2007 07:44:07 +0200
User-Agent: KMail/1.9.7
Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, david@lang.hm,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <200707121453.49616.rjw@sisk.pl> <87odig1idx.fsf@jbms.ath.cx> <20070717001239.GB20082@nineveh.local>
In-Reply-To: <20070717001239.GB20082@nineveh.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707170744.08191.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 17 Juli 2007 schrieb Joseph Fannin:
> Why are all these workarounds preferred, instead of proper suspend
> support for swap files?
> 
> IOW, what reasons are there to *not* support swap files, other than the
> hit-and-miss Linux suspend support?

If yoi want to go the kexec route to hibernation, the dumping kernel
would need to mount the filesystem to write to a file. Therefore the
suspending kernel would need to sync to disk and lock that file.

	Regards
		Oliver

