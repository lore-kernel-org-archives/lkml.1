Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYHKQmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYHKQmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYHKQlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:41:53 -0400
Received: from usul.saidi.cx ([204.11.33.34]:57507 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbYHKQlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:41:52 -0400
Message-ID: <48A06BBC.7060007@overt.org>
Date: Mon, 11 Aug 2008 09:41:32 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net>
In-Reply-To: <20080807134530.GB17062@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> Hmm?  UNBLOCKED means it is not being rfkilled.  Why is not working?  Put
> some debug printks on your toggle_radio callback, that might help fix the
> issue...
> 

Well, what I see is this:

At modprobe, I get an explicit unblock request. When I modify 'state' in sysfs,
I see appropriate requests to soft block and unblock. When I activate the hardware
kill switch, the rfkill state goes to hard_block but no one calls toggle_radio
and when I release the kill switch, the state goes to soft_block and no one
calls toggle_radio.

--phil
