Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZKPUEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZKPUEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZKPUEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:04:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbZKPUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:04:34 -0500
Date: Mon, 16 Nov 2009 12:03:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>, daniel@caiaq.de, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 00/10] LIS3: Feature updates and corrections
Message-Id: <20091116120327.7dd04a0d.akpm@linux-foundation.org>
In-Reply-To: <4B0025DE.8050402@tremplin-utc.net>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
	<4B0025DE.8050402@tremplin-utc.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Nov 2009 17:01:34 +0100
__ric Piel <eric.piel@tremplin-utc.net> wrote:

> Op 10-11-09 13:41, Samu Onkalo schreef:
> > This patch set has earlier been sent to lm-sensors list (thus patch v2).
> > No changes after that except to patch 0006 to make it applicable to
> > 2.6.32-rc6 (no functional changes).
> :
> > 
> > I have possibility to test these changes only with 8 bit version (lis302d).
> > Since part of the changes are specific to 12 bit device, I would appreciate
> > if someone could try these on 12 bit device.
> I've just tested them on a 12-bit device and it seems to go fine
> (excepted the rate setting in patch 8).
> 
> Andrew, maybe you could already queue the first 5 patches, as they all
> look fine and are fixing bugs. So we are sure they are there for 2.6.33
> :-) The rest of the patch series is useful but just "new feature" and
> some need more work.

OK, I merged the five.

We could sneak some/all of them into 2.6.32 I guess, if you think
that's warranted?

The ones which were From:yourself were missing Samu's Signed-off-by:. 
I added it.

"[PATCH v2 04/10] lis3: fix show rate for 8 bits chips" has a poor
changelog.  "fix with 8 bits sensors".  It failed to tell us what the
bug was, what its user-visible effects were, how it was fixed.

