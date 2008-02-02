Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYBBRjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYBBRjK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYBBRi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:38:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51512 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbYBBRi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:38:58 -0500
Date: Sat, 2 Feb 2008 18:39:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_SECTION_MISMATCH is replaced by CONFIG_DEBUG_SECTION_MISMATCH?
Message-ID: <20080202173901.GB24765@uranus.ravnborg.org>
References: <804dabb00802020820k567bf07cg780da10a0b083e6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802020820k567bf07cg780da10a0b083e6e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 12:20:41AM +0800, Peter Teoh wrote:
> I supposed CONFIG_SECTION_MISMATCH has been deprecated by
> CONFIG_DEBUG_SECTION_MISMATCH, as I found
> CONFIG_DEBUG_SECTION_MISMATCH in Makefile, Makefile.build and
> Makefile.modpost, but not the former symbol.   Moreover, setting the
> symbol in .config, and followed by make oldconfig will result in the
> non-debug symbol disappearing, but not the debug version.   Am I
> correct?

Simple error on my side.
Will fix while I touch this code for another reason.
Thanks for the report and proposed patch!

	Sam
