Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbXIUL7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbXIUL7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXIUL67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:58:59 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:45911 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbXIUL66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:58:58 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Date: Fri, 21 Sep 2007 21:58:47 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, nigel@suspend2.net,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Len Brown <lenb@kernel.org>
References: <1190266447.21818.17.camel@caritas-dev.intel.com> <20070920184106.79e1858a.akpm@linux-foundation.org> <200709211356.30291.rjw@sisk.pl>
In-Reply-To: <200709211356.30291.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709212158.50538.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Friday 21 September 2007 21:56:29 Rafael J. Wysocki wrote:
> [Besides, the current hibernation userland interface is used by default by
> openSUSE and it's also used by quite some Debian users, so we can't drop
> it overnight and it can't be implemented in a compatible way on top of the
> kexec-based solution.]

Could it be fudged by giving userland a null image and having (say) the first 
ioctl be one that triggers all the real work (with other ioctls being noops 
or such like, as appropriate)?

Regards,

Nigel
