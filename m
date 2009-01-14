Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbZANO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbZANO2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZANO2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:28:03 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:44751 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZANO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:28:01 -0500
Message-ID: <496DF66B.9050605@davidnewall.com>
Date: Thu, 15 Jan 2009 00:57:55 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Philippe De Muyter <phdm@macqel.be>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux kernel without file system
References: <496DA678.1090701@wpkg.org> <20090114093422.GA9771@frolo.macqel>
In-Reply-To: <20090114093422.GA9771@frolo.macqel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter wrote:
> Actually, I was thinking about reducing the footprint of my kernel by
> removing all the fs-related system calls, so the problem is not where
> the file-system is, but how to access (serial) devices without giving their
> "/dev/..." name.

That's fighting the UNIX design, in "which everything is a file."  You
can remove all of the disk-based filesystems, but if you try to remove
open, close, read or write there'll be almost nothing that you can
usefully do.
