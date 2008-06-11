Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYFKSB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYFKSB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 14:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYFKSBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 14:01:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2974 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750737AbYFKSBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 14:01:19 -0400
Date: Wed, 11 Jun 2008 20:01:04 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Kasindorf, Barry" <Barry.Kasindorf@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Message-ID: <20080611180104.GA4072@ucw.cz>
References: <87abhsp42o.fsf@basil.nowhere.org> <6096959DEF5C9447A6BF80BDC7EB9EDC08650A67@SBOSEXMB1.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6096959DEF5C9447A6BF80BDC7EB9EDC08650A67@SBOSEXMB1.amd.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-06-11 09:29:29, Kasindorf, Barry wrote:
> Yes,
> This is visible to userspace. The corresponding changes to the usermode
> code have been sent to the oProfile list. The confusion is that it is
> not AMD Family 10 but it is Family 16(10h). This can be confusing so we
> changed it.

...so we require users to upgrade userspace tools at the same moment
they upgrade kernel, and they can't go to the old kernel. Bad.

(Please mention userspace change in changelog).

I don't think potential for confusion is that big... and perhaps you
can do s/10/10h/ in userspace tools?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
