Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968Ab0AXHpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0AXHpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282Ab0AXHpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:45:31 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:43698 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab0AXHpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:45:30 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 02:45:30 EST
Date: Sun, 24 Jan 2010 13:11:18 +0530
From: Himanshu Chauhan <himanshu@symmetricore.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Kernel Newbies <kernelnewbies@nl.linux.org>, Greg Kroah <greg@kroah.com>
Subject: sysfs_ops show vector: size of buffer not required?
Message-ID: <20100124074118.GA4201@himanshu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The sysfs_ops's show vector doesn't have a size of the
buffer given to the vector, while store on the other hand
has. What is the rationale behind it?

I see most of the implementations doing strcpy in the
show vectors. Ill behaved driver might overwrite the
given buffer when size is not known. Should this be addressed
by providing the buffer size along with the buffer pointer?

Thanks

Best Regards
Himanshu
