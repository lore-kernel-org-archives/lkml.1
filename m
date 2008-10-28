Return-Path: <linux-kernel-owner+w=401wt.eu-S1753675AbYJ1RLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbYJ1RLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJ1RLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:11:07 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:37964 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbYJ1RLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:11:06 -0400
Date: Tue, 28 Oct 2008 18:11:37 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Long delays and keystrokes required - related to disk
	encryption?
Message-ID: <20081028170215.GA8820@localhost.aei.mpg.de>
References: <200810281744.52587.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810281744.52587.elendil@planet.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28.Oct'08 at 17:44:51 +0100, Frans Pop wrote:
> I'm seeing some very strange behavior with 2.6.28-rc2-95-g49fdf67 on my
> HP 2510p notebook.

Me too on my Vaio FZ240E.

> During the boot there are several places where I need to hit a key for the
> boot to continue. There are also some very long delays before the next
> syslog message is displayed.
> The boot does continue and regularly hitting a key helps (but does not get
> rid of all delays), but it is a huge regression from 2.6.27.

I have to press some key during boot too. But it does not happen at every boot.
And I've never seen this behaviour before 2.6.28-rc

> The delays seem to continue until file systems get mounted.
> 
> As the delays start at the point my system asks for the passphrase to
> unlock (LUKS) encrypted disks, I suspect it has to do with that.

I don't have any encrypted disks tough.

I think I remember one email by Andrew Morton about this keystroke to
continue to boot issue, so I Cc:-ed him.


> Especially since hitting a key seems to "trigger" new disk activity.
> 
> However, the delays happen _again_ during shutdown, which makes it extra
> strange that the system does behave normally when logged in.
> 
> During the first boot wireless networking failed. During the second boot,
> wireless networking did come up (without any relevant changes).
> This gave an interesting extra data point: with wireless the delays on
> shutdown started later: after iwlagn gets disabled.
> 
> Any ideas?
> 
> Cheers,
> FJP
