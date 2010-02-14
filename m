Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0BNWv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:51:27 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:39775 "HELO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751723Ab0BNWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:51:25 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Ed Tomlinson <edt@aei.ca>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Enable xy scrolling for Apple Magic Mouse
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<87y6j2eeqv.fsf_-_@troilus.org>
	<alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
	<201002141724.33223.edt@aei.ca>
Date: Sun, 14 Feb 2010 17:51:15 -0500
In-Reply-To: <201002141724.33223.edt@aei.ca> (Ed Tomlinson's message of "Sun,
	14 Feb 2010 17:24:32 -0500")
Message-ID: <87zl3bbfdo.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Tomlinson writes:

> Hi,
>
> Here is a patch that enables xy scrolling with the magic mouse.  I have also
> changed the accelleration logic to work better with xy scrolling.

Hi Ed,

Your other patch to call input_unregister_device() looks good -- thanks!

I've never used a horizontal scroll wheel -- what are the common uses
for it?  Why should the acceleration be separate for the two directions
rather than using the same factor?  Why does the kernel need to emulate
this rather than having user-space implement the emulation?

(If the answers to the last two questions justify putting this feature
in the kernel, my only suggestions on the patch are style-related:
scroll_accel{x,y} should probably be spelled scroll_accel_{x,y}, and
there are missing spaces around the / operator when calculating stepx
and stepy.)

Michael Poole
