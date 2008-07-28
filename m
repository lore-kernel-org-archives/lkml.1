Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYG1OSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYG1OSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYG1OSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:18:02 -0400
Received: from usul.saidi.cx ([204.11.33.34]:54618 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751423AbYG1OSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:18:01 -0400
Message-ID: <488DD500.1050805@overt.org>
Date: Mon, 28 Jul 2008 07:17:36 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ivo van Doorn <ivdoorn@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com> <488CF6D8.6000700@overt.org> <20080728030437.GC10672@khazad-dum.debian.net>
In-Reply-To: <20080728030437.GC10672@khazad-dum.debian.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> 
> There is a bunch of rfkill bug fix patches that was not merged in
> wireless-testing yet (which is a pity, it would be really good if they could
> go into 2.6.27).  One of those patches fixes the docs to make it clear that
> rfkill_force_state() is the way to go if you have events of any sort.
> 
> The big difference from get_state() is that rfkill_force_state() propagates
> state changes as soon as your driver notices them and sends them to rfkill
> through rfkill_force_state()... while get_state() can only do that when
> someone asks rfkill about the current state.

Fair enough. I'll update the patch when I get some time. And good point on how
to react to the event; dunno what I was(n't) thinking. :-)

--phil
