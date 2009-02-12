Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZBLVH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZBLVH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZBLVHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:07:16 -0500
Received: from kroah.org ([198.145.64.141]:60148 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbZBLVHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:07:15 -0500
Date: Thu, 12 Feb 2009 13:05:32 -0800
From: Greg KH <greg@kroah.com>
To: apw@canonical.com
Cc: linux-kernel@vger.kernel.org
Subject: checkpatch.pl --file gives wierd warning
Message-ID: <20090212210532.GA5727@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

With Linus's tree I get the following wierd warning when using the
--file option on checkpatch.pl:
	$ ./scripts/checkpatch.pl --file drivers/staging/phison/phison.c
	WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch

I'm guessing that this isn't intentional :)

Any ideas?

thanks,

greg k-h
