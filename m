Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZDFErW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZDFErW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 00:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbZDFErG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 00:47:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57309 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZDFErF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 00:47:05 -0400
Date: Sun, 5 Apr 2009 23:49:58 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Mark Ryden <markryde@gmail.com>
Cc: Greg KH <gregkh@suse.de>, David Shwatrz <dshwatrz@gmail.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: sysfs tagged directory support status (was:. Re: [PATCH 1/8]
	sysfs: Implement sysfs tagged directory support)
Message-ID: <20090406044958.GA8644@hallyn.com>
References: <dac45060904010300y7fe8a09dxb582929fc8018ec1@mail.gmail.com> <20090404030551.GC23516@suse.de> <dac45060904052128p6c539fe4p199a03f47a43a96b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dac45060904052128p6c539fe4p199a03f47a43a96b@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Ryden (markryde@gmail.com):
> Hello,
> I am sorry to hear that it is not merged yet.I hoped to try to start a
> project with network namespaces.

Sysfs tagged directories are not supported, but with 2.6.29 you
can use network namespaces.  There are some limits - you can't
move a physical network device out of the initial network
namespace, and (veth) devices which are not in the initial
network namespace just don't show up in /sys/class/net (since
we can't tag them).

But you can use network namespaces.

-serge
