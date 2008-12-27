Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYL0Uz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYL0Uz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYL0Uzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:55:48 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:40169 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbYL0Uzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:55:47 -0500
Date: Sat, 27 Dec 2008 21:57:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Improve dependency checks in kconfig
Message-ID: <20081227205720.GA16609@uranus.ravnborg.org>
References: <20081227090339.GA6279@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227090339.GA6279@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 10:03:39AM +0100, Sam Ravnborg wrote:

> With this change kconfig at least report one of the
> places where said symbol is defined. It is not perfect as
> we should report all places where a symbol is reported but
> for the cases I hit what we have here was good enough.

I gave it a spin and following two patches does:
- print out all places where a symbol is defined
- print out where we hit source "" issues

	Sam
