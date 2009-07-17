Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZGQO1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZGQO1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 10:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZGQO1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 10:27:11 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:59815 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZGQO1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:27:10 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2009 10:27:10 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l4k/5JNxQS9/mlgQN8MNJM7aBYkS5d19bw0J2bZlU2nsoA+LlhPo6TNzDfaH7ZKVNW
         NPpLJnPS1ToxBB/SSIbJtf23YjrWf/WdrxBDYv+rPhwm64J0pLD7tZznWpcCb2cfIqAZ
         EZOlq2m6zRX4JYbofn7tqjUCwo0C3BwKiP4V4=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
Date: Fri, 17 Jul 2009 23:19:22 +0900
Message-ID: <aec7e5c30907170719re0b4152y987d30f8cdeb0cba@mail.gmail.com>
Subject: Re: MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>, Magnus Damm <damm@opensource.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 8:10 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> Add support for tmio_mmc hardware configurations, that lack the cnf io
> area, like SuperH SoCs. With this patch such hardware can pass a single
> ctl io area with the platform data.

Right, this need looks familiar. =)

Have you tested this on any specific platform?

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> CC: Magnus Damm <damm@opensource.se>
> ---
> Pierre, I know you wanted to step down as a MMC maintainer (thanks for
> your great work btw!), but since we don't have a new one yet, I'm CC-ing
> you.
>
> A version of this patch has previously been submitted by Magnus Damm
> (CCed), but it hasn't been accepted back at 2.6.29 times (about 4 months
> ago). Now this driver extension has become much simpler, so, I think,
> there should be no problem accepting this patch now.

Yes, this patch looks a bit simpler than what I posted earlier. Nice work.

I remember posting a series of patches for the tmio_mmc driver, but
only the fixes were accepted at that point. Is this patch all that is
needed to get tmio_mmc working on your platform, or are you planning
on posting some other patches as well?

Cheers,

/ magnus
