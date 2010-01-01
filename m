Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021Ab0AAR7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab0AAR7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 12:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697Ab0AAR7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 12:59:47 -0500
Received: from uiae.at ([83.151.28.67]:55310 "EHLO uiae.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0AAR7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 12:59:47 -0500
Date: Fri, 1 Jan 2010 18:59:36 +0100
From: Michael Schutte <michi@uiae.at>
To: linux-kernel@vger.kernel.org
Cc: Samuel Thibault <samuel.thibault@labri.fr>
Subject: Re: [PATCH] fs/compat_ioctl.c: Add KD[GS]KBDIACRUC to the
	compatible list
Message-ID: <20100101175936.GA2878@graeme>
References: <20100101135606.GA3189@graeme> <201001011820.51144.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001011820.51144.arnd@arndb.de>
Jabber-ID: michi@uiae.at
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 06:20:50PM +0100, Arnd Bergmann wrote:
> On Friday 01 January 2010, Michael Schutte wrote:
> > Allow handling of Unicode compose sequences by 32-bit apps on a 64-bit
> > system.  The issue has been reported in <http://bugs.debian.org/540534>
> > and <http://lists.altlinux.org/pipermail/kbd/2009-December/000235.html>.
> > […]
> 
> Since 2.6.32, we handle all VT specific ioctls in the vt_compat_ioctl()
> function, which should fix this one implicitly. Please try to reproduce
> with a recent kernel.

Works indeed.  Thank you for the pointer and sorry for the noise.

Cheers,
-- 
Michael Schutte <michi@uiae.at>
