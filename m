Return-Path: <linux-kernel-owner+w=401wt.eu-S1753844AbXHZTjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbXHZTjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 15:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXHZTj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 15:39:26 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:47394 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXHZTjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 15:39:25 -0400
Date: Sun, 26 Aug 2007 13:38:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PROBLEM: Suspend corrupts bios clock since 2.6.21
In-reply-to: <fa.Hms7k1HwOwCbv7cPqUWGLhT5uyk@ifi.uio.no>
To: Andreas Steffan <a.steffan@deas-online.de>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pavel@suse.cz, linux-kernel@vger.kernel.org
Message-id: <46D1D6D1.5040203@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Hms7k1HwOwCbv7cPqUWGLhT5uyk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Steffan wrote:
> Hallo everybody,
> 
> I am running fedora core 7 on my Dell latitude D810 notebook (BIOS
> rev A05).
> 
> Since 2.6.21 I found that suspending (to disk and to ram) corrupts
> the bios clock most of the time (not always). The corruption is
> happening during suspend. When I enter the system bios right after
> I switch the system back on, I find the bios clock is set to a time
> far in the future (many years). I guess that problem is related to
> the clock changes that where introduced with 2.6.21.
> 
> Please let me know if you want me to provide further information to
> get this problem fixed.
> 
> If there is a known quirk to work around this problem, I would
> really appreciate a hint.
> 
> PS: I have not yet tried 2.6.22.4-65.fc7, but the latest 2.6.22 kernel
> before showed the same behaviour for me.

Please check if PM_TRACE is enabled in your kernel configuration. It 
will do this intentionally.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

