Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbYBFB3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbYBFB3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756031AbYBFB24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:28:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424AbYBFB2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:28:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Date: Wed, 6 Feb 2008 02:27:13 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080205190600.GB11613@elf.ucw.cz>
In-Reply-To: <20080205190600.GB11613@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060227.14385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of February 2008, Pavel Machek wrote:
> 
> This rewrites wakeup code to .c, and it fixes stack (should use movl
> ,%esp, not movw). Testers wanted. Makefile infrastructure was done by
> hpa, cleanups by rjw.

I'll test it tomorrow and I still have some more cleanups (I was distracted by
a nasty scheduler issue in the current mainline).

Thanks,
Rafael
