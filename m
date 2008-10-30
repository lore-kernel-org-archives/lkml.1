Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbYJ3TtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbYJ3TtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYJ3TtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:49:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52828 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYJ3TtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:49:01 -0400
Date: Thu, 30 Oct 2008 20:50:31 +0100
From: Pavel Machek <pavel@suse.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081030195031.GA22805@elf.ucw.cz>
References: <200810281744.52587.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810281744.52587.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 17:44:51, Frans Pop wrote:
> I'm seeing some very strange behavior with 2.6.28-rc2-95-g49fdf67 on my
> HP 2510p notebook.

> During the boot there are several places where I need to hit a key for the
> boot to continue. There are also some very long delays before the next
> syslog message is displayed.
> The boot does continue and regularly hitting a key helps (but does not get
> rid of all delays), but it is a huge regression from 2.6.27.
> 
> The delays seem to continue until file systems get mounted.
> 
> As the delays start at the point my system asks for the passphrase to
> unlock (LUKS) encrypted disks, I suspect it has to do with that.
> Especially since hitting a key seems to "trigger" new disk activity.
> 
> However, the delays happen _again_ during shutdown, which makes it extra
> strange that the system does behave normally when logged in.

Try "nohz=off highres=off"...
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
