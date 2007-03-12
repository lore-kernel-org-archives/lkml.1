Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXCLRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXCLRxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXCLRxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:53:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:62553 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbXCLRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:53:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=cooBZ64O8313wz+hTZO6BM3DnzHY6ty5JdiC/goo+TKbZkkj9nFBmNqvj5oUO6Y+/7Be6JmI4OjN5MqDqqeeKVoBaz1HfzBmHlgkd2aI1+k5XHU0EUQcn8S+jUfeTYqJwjgCgugMYGUV5WsPg8bepLRtVeLtj3tvfBAkvFuh2xY=
Date: Mon, 12 Mar 2007 20:49:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070312174947.GA10287@cvg>
References: <Pine.LNX.4.61.0703101724160.8799@yvahk01.tjqt.qr> <20070310194617.2aef1006@localhost> <Pine.LNX.4.61.0703101747530.8799@yvahk01.tjqt.qr> <20070310175058.GA19878@cvg> <Pine.LNX.4.61.0703101906070.8799@yvahk01.tjqt.qr> <20070310212730.GA2577@uranus.ravnborg.org> <Pine.LNX.4.61.0703102234210.26332@yvahk01.tjqt.qr> <20070310224534.GA3150@uranus.ravnborg.org> <20070311100723.GA10359@cvg> <20070311195033.GA3302@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070311195033.GA3302@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Sam Ravnborg - Sun, Mar 11, 2007 at 08:50:33PM +0100]

[... snipped ...]

| I would rather avoid adding the extra lines. In the
| 'office-suite' fashion I have cooked up a patch that specify
| the filename as part of the windows title.
| 
| To make the conversion we should consider renaming from
| current "Load alternate" to "Open config file..."
| and likewise "Save alternate" to "Save config file as..."
| 
| Comments?
| 
| 	Sam
|
[... snipped ...]

Hi Sam,

I've tested it and I think all do its work as it should...
But only two points may be additionally changed:

	1) I think it is better to show main dialog title in form:
	"Linux Kernel v.2.6.21-rc3 Configuration - config file: .config"
	2) You've set menu_backtitle with 128 characters may be we
	should set as PATH_MAX+1+128 - to hold a whole config file?

And renaming "Load alternate" to "Open config file..." and
"Save alternate" to "Save config file as..." is fine I guess.

Hey kernel list - what's your comments? :)

	Cyrill

