Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbZANOtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbZANOtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:49:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZANOtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:49:45 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:2213 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbZANOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:49:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAIeJbUnCTtAn/2dsb2JhbACBbMwMhW8
Date: Wed, 14 Jan 2009 15:49:38 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: David Newall <davidn@davidnewall.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
Message-ID: <20090114144937.GA21043@frolo.macqel>
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel> <496DF66B.9050605@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496DF66B.9050605@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 12:57:55AM +1030, David Newall wrote:
> Philippe De Muyter wrote:
> > Actually, I was thinking about reducing the footprint of my kernel by
> > removing all the fs-related system calls, so the problem is not where
> > the file-system is, but how to access (serial) devices without giving their
> > "/dev/..." name.
> 
> That's fighting the UNIX design, in "which everything is a file."  You
> can remove all of the disk-based filesystems, but if you try to remove
> open, close, read or write there'll be almost nothing that you can
> usefully do.

Of course, I need read, write and ioctl and socket and friends but I do not
need open, creat, link, rename etc.

Philippe
