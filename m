Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbYA2LQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbYA2LQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 06:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbYA2LQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 06:16:27 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:59436 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbYA2LQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 06:16:26 -0500
Date: Tue, 29 Jan 2008 11:16:22 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: 2.6.24 panics initializing ne2k in mips.
Message-ID: <20080129111622.GC7237@linux-mips.org>
References: <200801280217.38273.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801280217.38273.rob@landley.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 02:17:37AM -0600, Rob Landley wrote:

> The 2.6.23 kernel built for mips with the attached .config works fine for me 
> under qemu (both big endian and little endian), but a 2.6.24 mips kernel 
> segfaults initializing the ne2k driver (again when run under qemu).
> 
> I've traced it to this commit:

Known problem.  The issue only hits when probing IRQs as the NE2000 driver
does.  This got dropped on the floor in December.

  Ralf
