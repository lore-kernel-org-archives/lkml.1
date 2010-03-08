Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0CHV3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:29:43 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:12829 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab0CHV3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:29:40 -0500
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 16:29:40 EST
Date: Mon, 8 Mar 2010 15:20:04 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Upstream first policy
Message-ID: <20100308212004.GA1314123@hiwaay.net>
References: <elwcV-406-1@gated-at.bofh.it> <elHL4-42q-5@gated-at.bofh.it> <elP5U-6Ku-29@gated-at.bofh.it> <elPyV-7zE-7@gated-at.bofh.it> <elQbE-8ll-7@gated-at.bofh.it> <elQv0-vu-17@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100308191749.19e20430@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Alan Cox  <alan@lxorguk.ukuu.org.uk> said:
>Its path based in the sense that public_html has a path based meaning by
>convention understood by httpd. Copy a jpeg into your public_html and it
>will be labelled up for http access under the Fedora shipped rule sets.

I'm pretty sure the "copy into a directory" only gets the correct label
by inheritance from the parent directory.

"mkdir public_html" only gets the correct label by running the
restorecond daemon, which is really kind of a hack.  You have a
user-space daemon that watches for creation of specific things with
inotify, and resets their label when a match is found.  It doesn't scale
up to many rules, certainly not the full SELinux list.

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
