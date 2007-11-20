Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbXKTANB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbXKTANB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXKTAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:12:52 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:55163 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXKTAMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:12:52 -0500
Date: Mon, 19 Nov 2007 19:12:48 -0500 (EST)
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: Nick Warne <nick@ukfsn.org>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: sb live (emu10k1) stops working between 2.6.23.1 and 2.6.23.7
In-Reply-To: <20071119225542.1e0577e4@linuxamd.linicks.net>
Message-ID: <Pine.GSO.4.58.0711191903410.22461@denali.ccs.neu.edu>
References: <20071119225542.1e0577e4@linuxamd.linicks.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 19 Nov 2007, Nick Warne wrote:

> nick@linuxamd:nick$ sudo /usr/sbin/alsactl -F restore
> /usr/sbin/alsactl: set_control:970: failed to obtain info for control
> #228 (No such file or directory)
> /usr/sbin/alsactl: set_control:970: failed to obtain info for control
> #232 (No such file or directory)

Hi all,

I get a similar error message when I take Takashi's advice:
dampkring ~ # alsactl -F restore
alsactl: set_control:968: failed to obtain info for control #222 (No such
file or directory)
alsactl: set_control:968: failed to obtain info for control #226 (No such
file or directory)

However it did restore my digital audio output.  Its strange that I was
unable to get it working myself using alsamixer, even when I took
screenshots of the settings under 2.6.23.1, and duplicated them under
2.6.23.7.  Oh well, the SB Live has to have the most convoluted alsamixer
setup out of any sound card, so I suppose I might have missed something.
Thanks for your help in getting this working again!

Jim Faulkner
