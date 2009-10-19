Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZJSQ0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZJSQ0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 12:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZJSQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 12:26:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848AbZJSQ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 12:26:04 -0400
From: Andreas Schwab <schwab@redhat.com>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf: Reorder objects in Makefile to favor platform default.
References: <alpine.DEB.2.00.0910190415430.13303@andre.icculuslan>
X-Yow: I'm in ATLANTIC CITY riding in a comfortable ROLLING CHAIR...
Date: Mon, 19 Oct 2009 18:26:06 +0200
In-Reply-To: <alpine.DEB.2.00.0910190415430.13303@andre.icculuslan> (Ryan
	C. Gordon's message of "Mon, 19 Oct 2009 10:25:43 -0400 (EDT)")
Message-ID: <m3r5szfizl.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ryan C. Gordon" <icculus@icculus.org> writes:

> Now the kernel will try the compatibility formats as a backup if the actual
> system format rejects the binary. As almost all binaries loaded won't be
> compatibility formats, this saves a few cycles for each process.

Perhaps this should be configurable.  For a 64-bit arch with mostly
32-bit userspace the compat format should probably be tried first.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
