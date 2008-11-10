Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYKJXPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYKJXPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYKJXP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:15:28 -0500
Received: from relay3-v.mail.gandi.net ([217.70.178.77]:33285 "EHLO
	relay3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYKJXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:15:27 -0500
Date: Tue, 11 Nov 2008 00:15:24 +0100
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Re: Suspend to disk broken in latest 2.6.28-rc3
Message-ID: <20081110231524.GA18971@mobydick>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>
References: <20081109195033.GA1335@mobydick> <20081110094239.GA14204@atrey.karlin.mff.cuni.cz> <20081110221343.GA17951@mobydick> <200811101506.53324.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811101506.53324.jbarnes@virtuousgeek.org>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK
	'.w 3:{EoxBR
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello Jesse,

Thanks for the prompt reply.

On Mon, Nov 10, 2008 at 03:06:52PM -0800, Jesse Barnes wrote:
> If you have radeon loaded but DRI was never enabled, you'll likely see a 
> crash.  That's because the radeon driver doesn't map the registers it needs 
> for suspend/resume at load time; they only get mapped by DRI initialization 
> code which lives in the X driver.  There's a patch in 
> http://bugzilla.kernel.org/show_bug.cgi?id=11891 that might help you...

This one I guess:
http://bugzilla.kernel.org/attachment.cgi?id=18644&action=view

Let me give it a shot, I'll keep you posted.
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
