Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZCDHsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZCDHsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZCDHr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:47:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZCDHrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:47:55 -0500
Date: Wed, 4 Mar 2009 08:47:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc: PM notifiers are not called during hibernation
Message-ID: <20090304074733.GA1405@ucw.cz>
References: <200901292254.09562.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901292254.09562.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-01-29 22:53:57, Andrey Borzenkov wrote:
> rc2 and now rc3
> 
> Orinoco driver uses notifications to request firmware before 
> suspend/hibernation. This is OK for suspend, but does not seem to work 
> for hibernation. I get what suspiciously looks like 60 seconds timeout 
> for request_firmware, but I do not see either usual request_firmware 
> output, nor debug output.
> 
> Suspend is OK.
> 
> orinoco notification handlers is:

Is it fixed in newer -rc? If not, does rafael know?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
