Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbXCFHiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbXCFHiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933975AbXCFHiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:38:02 -0500
Received: from twin.jikos.cz ([213.151.79.26]:40313 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106AbXCFHiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:38:00 -0500
Date: Tue, 6 Mar 2007 08:37:38 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Robert Marquardt <marquardt@codemercs.com>
cc: Li Yu <raise.sail@gmail.com>, Vincent Legoll <vincentlegoll@gmail.com>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       Harold Sargeant <harold-sargeant@ntlworld.com>,
       Greg Kroah Hartman <greg@kroah.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-usb-devel] [DOC] The documentation for HID Simple Driver
 Interface 0.5.0
In-Reply-To: <45ED11DE.4080304@codemercs.com>
Message-ID: <Pine.LNX.4.64.0703060836360.10909@twin.jikos.cz>
References: <200703051532096508636@gmail.com> <Pine.LNX.4.64.0703052304070.10909@twin.jikos.cz>
 <45ED11DE.4080304@codemercs.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Robert Marquardt wrote:

> I do not know too much about the Linux innards, but my opinion is that 
> the HID API to userland should be the bare reports. Windows is handling 
> it that way for a good reason. Far too many HID devices have either 
> non-informative descriptors (declaring a byte array report) or declaring 
> a report which does not match the data contained. Parsing a report is 
> definitely a userland job.

Which is exactly what the new hidraw interface is going to provide.

-- 
Jiri Kosina
