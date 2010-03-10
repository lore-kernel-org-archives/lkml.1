Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab0CJKMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:12:40 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51083 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0CJKMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:12:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=r2jA3pX/eHkOzH9k3xWH1MHKVVVpBS6+lG/l/Pygvt//BurOr/5FVY0Ho22hA8GB1P
         MNErDxcVJVpjBcadkme2wPcQU2UlKZBmKC6V9KA9JJoNSHpZ/QDY/KycHYgRyFThzXqt
         gsSLucKSllv29KPQtqXa/3IyQEMmk9ibH9PcQ=
Date: Wed, 10 Mar 2010 13:12:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de,
       kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
Subject: smatch_scripts/whitespace_only.sh
Message-ID: <20100310101224.GC6321@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a script to check that a patch only changes white space.
It compiles the files before and after the patch is applied and 
verifies that they are the same.

You'll need to compile smatch:
	git pull git://repo.or.cz/smatch.git
	make
	cd /path/to/kernel/src/
	/path/to/smatch_scripts/whitespace_only.sh <patch>

Adding or removing parenthesis and curly braces counts as a code 
change.  Changes to comments, #if 0, white space changes do not.

You can fix a lot of style violations if you limit yourself to 
adding and removing tabs, spaces and new lines.  Then the next 
patch could remove unneeded parenthesis.  It would be easier to
audit that way instead of everything mixed together.

regards,
dan carpenter

PS.  I feel really bad slagging the newbies trying to help.  
Could we fix checkpatch.pl to not complain about line lengths?
Also could we tell them to stay in staging where no one cares
about git blame?

