Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYAFSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYAFSJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 13:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYAFSJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 13:09:12 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60556 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbYAFSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 13:09:11 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478118E1.1090804@s5r6.in-berlin.de>
Date: Sun, 06 Jan 2008 19:07:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <Pine.LNX.4.44L0.0801061206500.7367-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801061206500.7367-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Another disadvantage appears when somebody tries by hand to remove a 
> component (like SCSI) and finds that it magically reappears.  Evidently 
> something is selecting it, but there's no way to find out what.

xconfig's "Show Debug Info" and menuconfig's help screen show you
whether an option was selected and by which option.  xconfig calls it
"reverse dep:", menuconfig says "Selected by:".

Of course these features are merely there because 'select' creates this
problem in the first place.
-- 
Stefan Richter
-=====-==--- ---= --==-
http://arcgraph.de/sr/
