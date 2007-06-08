Return-Path: <linux-kernel-owner+w=401wt.eu-S1030986AbXFHSA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030986AbXFHSA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935947AbXFHSAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:00:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935013AbXFHSAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:00:48 -0400
Message-ID: <46699945.6020106@redhat.com>
Date: Fri, 08 Jun 2007 14:00:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: USB development list <linux-usb-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: blank filenames in /sys/modules, kernel 2.6.21
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We just found a file with this name in 2.6.21:

Directory name: /sys/module/nousb/parameters
File name:      ""

IOW the file has an empty name. Is this intentional?
It sure confuses updatedb...

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=242715
