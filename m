Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbYG0WaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbYG0WaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 18:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbYG0WaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 18:30:04 -0400
Received: from usul.saidi.cx ([204.11.33.34]:40826 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758522AbYG0WaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 18:30:03 -0400
Message-ID: <488CF6D8.6000700@overt.org>
Date: Sun, 27 Jul 2008 15:29:44 -0700
From: Philip Langdale <philipl@overt.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill
References: <488CBBAB.6010508@overt.org> <200807272259.44364.IvDoorn@gmail.com>
In-Reply-To: <200807272259.44364.IvDoorn@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivo van Doorn wrote:
> 
> You don't seem to be using rfkill_force_state() which is required to inform the rfkill
> layer about the state changes.

Hmm? According to rfkill.txt, one can either use force_state() or implement the
get_state() hook, and I have done the later. If this is not the correct method,
can you please explain when I should be using force_state?

--phil
