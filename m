Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYFTIz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYFTIz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFTIzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:55:14 -0400
Received: from saeurebad.de ([85.214.36.134]:53166 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYFTIzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:55:12 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm patches for 2.6.26-final
References: <alpine.DEB.0.82.0806200402030.12492@skynet.skynet.ie>
	<alpine.DEB.0.82.0806200645470.12492@skynet.skynet.ie>
Date: Fri, 20 Jun 2008 10:55:03 +0200
In-Reply-To: <alpine.DEB.0.82.0806200645470.12492@skynet.skynet.ie> (Dave
	Airlie's message of "Fri, 20 Jun 2008 06:47:11 +0100 (IST)")
Message-ID: <87bq1wpjtk.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dave Airlie <airlied@linux.ie> writes:

>> There is also an oops fixer reported in the drm ioctl handler.

>> commit 41ee2ff404ec76194315aeed57ac973b010abe1d
>> Author: Johannes Weiner <hannes@saeurebad.de>
>> Date:   Fri Jun 13 15:04:40 2008 +1000
>> 
>>     drm: use drms ioctl cmd not what we get passed from userspace.
>>     
>>     This enforces us to use the drm ioctl types so read/write works correctly and not believe
>>     what userspace tells us.
>>     
>>     It does this hopefully without breaking the drm api.
>>     
>>     Fixes bug from thread: BUG: unable to handle kernel NULL pointer dereference (drm_getunique)
>>     
>>     Signed-off-by: Dave Airlie <airlied@redhat.com>

       Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
       Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

That was only a proposal, to which you did not reply at all [1] and just
silently picked it (without the credits).  Not very polite.

	Hannes

[1] http://lkml.org/lkml/2008/6/5/250
