Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbZDESN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbZDESN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZDESNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:13:48 -0400
Received: from mx03.syneticon.net ([78.111.66.105]:48242 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbZDESNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:13:47 -0400
Message-ID: <49D8F4D5.7010205@wpkg.org>
Date: Sun, 05 Apr 2009 20:13:41 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The replace-via-truncate and replace-via-rename workarounds are there
>> for the benefit of KDE, and GNOME, which in some configurations
>> apparently will replace hundreds of dot files when the desktop is
>> started up, for no reason that I can understand.  (Not such a great
>> idea for SSD write endurance!)  Some people apparently spend hours
>> making sure that their windows are exactly positioned the way they
>> want it when their desktop starts up, and if the system crashes while
>> their desktop is starting up, those they could lose their window
>> positions, which apparently made a whole bunch of users cranky.  In
>> practice, most of the editors that I'm familiar with have been around
>> for a while, have needed to make sure that that cases such as yours
>> wouldn't result in data loss, and so are pretty good about using
>> fsync() so that users' files wouldn't be lost, no matter what the
>> filesystem or operating system being used.
> 
> Its more than losing window postions.  I've been using ext4 with kde 4.2.1 
> along with some experimental modules (drm for xorg for r600 support, btrfs) 
> and a few patches.  As expected this has caused a few crashes.  I have had 
> kde lose desktop setup info (eg. it forgot it was using xrender accel).  I 
> have also had kmail lose all its configuration - which is a pita to rebuild.  
> Note that these crashes occur long after kde has been started...

I've lost contents of my /etc/shadow file some time ago.
Great fun after reboot.

But it also means that the problem begins not with KDE and Gnome, but 
much, much earlier.


-- 
Tomasz Chmielewski
http://wpkg.org
