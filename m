Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995Ab0AIXT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0AIXT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 18:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739Ab0AIXT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 18:19:57 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:40552 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab0AIXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 18:19:57 -0500
Subject: Re: ACPI quirks - acpi_osi="!Windows 2006" required on FSC Amilo
 notebooks to enable brightness keys
From: Peter Paul <abnominales@web.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100109231122.GA19789@srcf.ucam.org>
References: <539929391@web.de> <20100109202642.GA18657@srcf.ucam.org>
	 <1263073701.6497.75.camel@rechenknecht2k7>
	 <20100109220606.GA19441@srcf.ucam.org> <1263076707.1675.6.camel@virtubuntu>
	 <20100109231122.GA19789@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jan 2010 00:19:55 +0100
Message-ID: <1263079195.20284.2.camel@virtubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18kihxMxYwbD2DEK88YjidICpEkzoJn4e/c28aW
	lDC7K+n6evCajeNp7KfzLmfV+YZfXprvVbt9L1RwDZmbSd+A5e
	zHhYhgVao=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09.01.2010, 23:11 +0000 Matthew Garrett wrote:
> It all looks like it should work. What do you have in /proc/acpi/video ?

/proc/acpi/video/:
GFX0

/proc/acpi/video/GFX0:
DD01  DD02  DD03  DD04  DD05  DOS  info  POST  POST_info  ROM

/proc/acpi/video/GFX0/DD01:
brightness  EDID  info  state

/proc/acpi/video/GFX0/DD02:
brightness  EDID  info  state

/proc/acpi/video/GFX0/DD03:
brightness  EDID  info  state

/proc/acpi/video/GFX0/DD04:
brightness  EDID  info  state

/proc/acpi/video/GFX0/DD05:
brightness  EDID  info  state

But like I said, it is possible to adjust the brightness software side
(even without acpi_osi parameter), it's only the keys that don't work.

