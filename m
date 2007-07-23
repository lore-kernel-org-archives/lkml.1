Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbXGWTM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbXGWTM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbXGWTMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:12:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762099AbXGWTMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:12:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
X-Fcc: ~/Mail/linus
Cc: Al Viro <viro@ftp.linux.org.uk>, Alan Modra <amodra@bigpond.net.au>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
In-Reply-To: Sam Ravnborg's message of  Monday, 23 July 2007 20:00:48 +0200 <20070723180048.GA8268@uranus.ravnborg.org>
X-Zippy-Says: I'll clean your ROOM!!  I know some GOOD stories, too!!  All about
    ROAD Island's, HUSH Puppies, and how LUKE finds GOLD on his LAND!!
Message-Id: <20070723191215.2F9484D058D@magilla.localdomain>
Date: Mon, 23 Jul 2007 12:12:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> rm vmlinux*; time make vmlinux
> 
> Vanilla tree: ~7,7 sec
> With single shot ld (Roland's patch): 8,3 secs

Shouldn't you compare:
	rm vmlinux*; find . -name built-in.o -print | xargs rm
	time make vmlinux
or something like that?


Thanks,
Roland
