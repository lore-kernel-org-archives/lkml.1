Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZLSXfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZLSXfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZLSXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:35:06 -0500
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:53837
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbZLSXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:35:05 -0500
Date: Sun, 20 Dec 2009 00:34:57 +0100
From: Michael Guntsche <mike@it-loops.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: mjt@tls.msk.ru, mmarek@suse.cz, sam@ravnborg.org
Subject: Re: 2.6.33-rc1 Reboot right after bootloader
Message-ID: <20091219233457.GA4288@trillian.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening,

I took me some time but I tracked down my reboot problem. The culprit is
commit 

4a2ff67c88211026afcbdbc190c13f705dae1b59: kbuild: fix bzImage build for
x86

The system I am compiling the kernel on has dash as its defaults shell.
With the commit applied I get an instant reboot, reverting the patch
makes it work again. 
If I switch my default shell to bash it works BOTH times.
I do not know why the shell makes a difference here though.
The version of dash is 0.5.5.1 from debian unstable.

Kind regards,
Michael

