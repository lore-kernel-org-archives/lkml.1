Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbZF3EoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbZF3EoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 00:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZF3En4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 00:43:56 -0400
Received: from fmailhost06.isp.att.net ([204.127.217.106]:55296 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZF3Enz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 00:43:55 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A49980E.2010405@lwfinger.net>
Date: Mon, 29 Jun 2009 23:43:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: need help figuring out what makes my wireless"iwconfig" not respond
References: <4A499531.4040001@gmail.com>
In-Reply-To: <4A499531.4040001@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> from 2.6.31-rc1 to present there was a couple of commits for
> wireless. prior to that the wireless on my machine(imac)
> was o.k.,
> Now the wireless does work(streams music,t.v. etc..)
> but when I look at iwconfig there's nothing no info.
> (I use wicd as my connection manager, and in the bottom corner
> of the screen the transmit power is down to almost nothing,
> causing wicd to constantly reconnect)
> 
> out of a random guess what commit might have caused this, so I can at least
> fix this over here(that is until the manufacturer comes out with a new
> version). I can go in and individually revert all of the wireless, but
> before that
> I want a quick lead.
> 
> any ideas?
> 

If you have a git tree, use the "git bisect" commands to find the bad
commit.
