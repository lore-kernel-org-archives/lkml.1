Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZKUTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZKUTNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 14:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZKUTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 14:13:20 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47589 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZKUTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 14:13:20 -0500
Date: Sat, 21 Nov 2009 20:13:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: Re: Defining led's triggers as separate class
Message-ID: <20091121191319.GD2444@ucw.cz>
References: <20091111180718.GH3495@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111180718.GH3495@enneenne.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-11 19:07:18, Rodolfo Giometti wrote:
> Hello,
> 
> it could be sane moving triggers core from leds directory and defining
> them as a separate class in order to be used by other subsystem?
> 
> For instance I have a voltage regulator (which should be logically
> implemented into current regulator class) who must be enabled/disabled
> when the LCD is turned on/off... if the driver was implemented as led
> class then I can use the trigger ledtrig-backlight.c but as regulator
> I can not.

Well, and then user does echo 'hddactivity' > trigger, and your
voltage regulator will have some fun?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
