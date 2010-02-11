Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab0BKDUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 22:20:20 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:60732 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753328Ab0BKDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 22:20:17 -0500
From: Michael Poole <mdpoole@troilus.org>
To: Ed Tomlinson <edt@aei.ca>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add a device driver for the Apple Magic Mouse.
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz>
	<87y6j2eeqv.fsf_-_@troilus.org> <87pr4eeemz.fsf_-_@troilus.org>
	<201002102205.58967.edt@aei.ca>
Date: Wed, 10 Feb 2010 22:20:13 -0500
In-Reply-To: <201002102205.58967.edt@aei.ca> (Ed Tomlinson's message of "Wed,
	10 Feb 2010 22:05:58 -0500")
Message-ID: <878wb0e9w2.fsf@troilus.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Tomlinson writes:

> Hi,
>
> When I apply this to head, I get:
>
> drivers/hid/hid-magicmouse.c: In function 'magicmouse_probe':                                                         
> drivers/hid/hid-magicmouse.c:393: error: too many arguments to function 'hdev->hid_output_raw_report'                 
> drivers/hid/hid-magicmouse.c:400: error: too many arguments to function 'hdev->hid_output_raw_report'                 
>
> I only need the second patch - the first seems to be in tree.
>
> Any ideas as to what I am missing?
>
> TIA
> Ed

You're missing the patch that makes hid_output_raw_report() more generic.
It is in the HID tree[1] as commit d4bfa033.

[1]- http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git

Michael Poole
