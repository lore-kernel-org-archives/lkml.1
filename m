Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYKSVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYKSVuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYKSVtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:49:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:58755 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYKSVtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:49:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:cc:subject:content-type
         :content-transfer-encoding:from;
        b=gUOanNkmwycDovmhw60SyPp3crnDiebwz3vbyay8YRz9QZBgIHBibhUCZTPUWDZ3xz
         sUeCjYSSwx4vfSYAJ/3jR45QO4uKFa2YZXHBF90iHis2jN3L3mhNVtZSbSF5U5gMc+U9
         z++N6rLLBly4fSfZHT+kLO9NHYBHqFo2l+2gE=
Message-ID: <492489D1.5080502@gmail.com>
Date: Wed, 19 Nov 2008 16:49:05 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
CC: Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       adobriyan@gmail.com, Patrick McHardy <kaber@trash.net>, den@openvz.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Current state of Network Namespaces (NETNS, CLONE_NEWNET)?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the shotgun mail, but in the end,  it's
not clear who can best answer my question(s).

I'm currently trying to add documentation of all of
the undocumented CLONE_* flags.  One of these is
CLONE_NEWNET, and I could use (quite a lot of) help.  

My questions:

What is the current state of the network namespace 
implementation?  Is it complete?  

What objects are considered part of the network 
namespace, and therefore distinct for a new network 
namespace?

Is there any documentation for network namespaces 
already?

Are there any test programs for network namespaces?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

