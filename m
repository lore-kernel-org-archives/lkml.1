Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXLITfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXLITfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 14:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXLITfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 14:35:36 -0500
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:11989 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbXLITfg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 14:35:36 -0500
From: Frans Pop <elendil@planet.nl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: menuconfig: fail with clearer error if curses.h N/A
Date: Sun, 9 Dec 2007 20:35:32 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>
References: <200710142323.21139.elendil@planet.nl> <20071209191317.GA8496@uranus.ravnborg.org>
In-Reply-To: <20071209191317.GA8496@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712092035.33056.elendil@planet.nl>
X-OriginalArrivalTime: 09 Dec 2007 19:35:33.0266 (UTC) FILETIME=[AA10C720:01C83A9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 December 2007, Sam Ravnborg wrote:
> This is much better.

Thanks!

A few minor corrections maybe (nitpicks really).

>  *** Unable to find the ncurses libraries
>  *** or the required header files.

That first line is strangely short like this.
Move "or the" to the first line?

>  *** make menuconfig require the ncurses libraries

At least s/require/requires/ and probably add a period at end of the line.
I also suggest adding quotes around make menuconfig:
 *** 'make menuconfig' requires the ncurses libraries.

>  ***
>  *** Install ncurses (ncurses-devel) and try again

Again add a period at end of the line.

Cheers,
FJP
