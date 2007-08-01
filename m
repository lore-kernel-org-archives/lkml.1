Return-Path: <linux-kernel-owner+w=401wt.eu-S1759611AbXHAHgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759611AbXHAHgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbXHAHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:36:35 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:59527 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757721AbXHAHge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:36:34 -0400
Subject: Re: 2.6.23-rc1-mm2
	(vm-dont-run-touch_buffer-during-buffercache-lookups.patch)
From: Eric St-Laurent <ericstl34@sympatico.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 03:36:30 -0400
Message-Id: <1185953790.6393.20.camel@perkele>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-31-07 at 23:09 -0700, Andrew Morton wrote:

> +vm-dont-run-touch_buffer-during-buffercache-lookups.patch
> 
>  A little VM experiment.  See changelog for details.

> We don't have any tests to determine the effects of this, and nobody will
> bother setting one up, so ho hum, this remains in -mm for ever.

> I don't think there's any point in doing this until we have some decent
> testcases.


Hi Andrew,


For which problem this patch was coded?  Is it a potential fix to the
updatedb problem?

Is the patch effective without the filesystem dependant change you talk
about?  (I use reiserfs)

I've been thinking about a test case for the updatedb problem:

1. Script or program that create a large number of directories and zero
sized files.  Same setup for everyone to have reproducible results.

2. Run updatedb on those.

3. Observe the effects (with vmstat, slabinfo and meminfo) before,
during and after the updatedb run.

4. Do something to trigger some reclaim like copying a large file.

5. See the effects.


What do you think? What would be the ideal test case for the problem in
your opinion?


Best regards,

- Eric


