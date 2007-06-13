Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbXFMT7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbXFMT7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbXFMT7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:59:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:1089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbXFMT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:58:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=RBEcWX5MCaCeTU6Vdx+6zDGmFpT3nir83rNKG5HZ8D9DmGgYTA6vYOzOhIk55DuV//M6rqPovPrYvDawpHxuzRowzRkjxelGxWUMaw40ztC2lfJlPqdvgI21zqHZqbxEUoi5n/Ssh4xwLOJItmKiznsOCgVQdeuWf9RRvTR8B34=
Message-ID: <46704C44.8020602@googlemail.com>
Date: Wed, 13 Jun 2007 21:57:56 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       Dan Aloni <da-x@monatomic.org>,
       Chad Tindel <ctindel@users.sourceforge.net>,
       Jay Vosburgh <fubar@us.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       sparclinux@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Alex Riesen <raa.lkml@gmail.com>,
       Andi Kleen <ak@suse.de>, discuss@x86-64.org,
       Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions v3
References: <46704923.1010009@googlemail.com>
In-Reply-To: <46704923.1010009@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc4.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Networking

Subject    : commit 9093bbb2d96d0184f037cea9b4e952a44ebe7c32 broke the bonding driver
References : http://lkml.org/lkml/2007/6/13/65
Submitter  : Dan Aloni <da-x@monatomic.org>
Handled-By : Stephen Hemminger <shemminger@linux-foundation.org>
Status     : Unknown



Sparc64

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



Suspend

Subject    : hibernate(?) fails totally - regression
References : http://lkml.org/lkml/2007/6/1/401
Submitter  : David Greaves <david@dgreaves.com>
Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit 9666f4009c22f6520ac3fb8a19c9e32ab973e828
Status     : problem is being debugged



TTY

Subject    : OOPS (NULL pointer dereference) in v2.6.22-rc3
References : http://lkml.org/lkml/2007/6/1/389
             http://bugzilla.kernel.org/show_bug.cgi?id=8473
             http://bugzilla.kernel.org/show_bug.cgi?id=8574
Submitter  : Alex Riesen <raa.lkml@gmail.com>
Status     : problem is being debugged



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
