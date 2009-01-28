Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZA1Vex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZA1Vex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZA1Veo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:34:44 -0500
Received: from kroah.org ([198.145.64.141]:55981 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751584AbZA1Veo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:34:44 -0500
Date: Wed, 28 Jan 2009 13:33:22 -0800
From: Greg KH <greg@kroah.com>
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: open(2) says O_DIRECT works on 512 byte boundries?
Message-ID: <20090128213322.GA15789@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at open(2), it says that O_DIRECT works on 512 byte boundries
with the 2.6 kernel release:
	Under Linux 2.4, transfer sizes, and the alignment of the user
	buffer and  the file offset must all be multiples of the logical
	block size of the file system.  Under Linux 2.6, alignment  to
	512-byte  boundaries suffices.

However if you try to access an O_DIRECT opened file with a buffer that
is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
read.)

Is this just a mistake in the documentation?  Or am I reading it
incorrectly?

I have a test program that shows this if anyone wants it.

thanks,

greg k-h
