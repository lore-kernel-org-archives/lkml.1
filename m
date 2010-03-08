Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0CHTS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:18:58 -0500
Received: from ppp173-197.broadband.gorge.net ([209.216.173.197]:59659 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754533Ab0CHTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:18:53 -0500
Date: Mon, 8 Mar 2010 19:17:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: Upstream first policy
Message-ID: <20100308191749.19e20430@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<20100308184521.GK30031@ZenIV.linux.org.uk>
	<alpine.LFD.2.00.1003081051130.3989@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.7; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> always worked. I don't even understand why you have that crazy "either or" 
> mentality to begin with. Why?
> 
> It's not "either pathname or inode". I'm saying _both_ make sense. 

SELinux uses both. Things like "I put a file in my public_html directory"
are a good example.

Its object based in the sense that the origin of the data might matter
(eg 'no app which opens the credit card db creates a file httpd can send')

Its path based in the sense that public_html has a path based meaning by
convention understood by httpd. Copy a jpeg into your public_html and it
will be labelled up for http access under the Fedora shipped rule sets.

Alan

