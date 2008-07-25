Return-Path: <linux-kernel-owner+w=401wt.eu-S1752247AbYGYP50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbYGYP50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 11:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYGYP5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 11:57:17 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57149 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbYGYP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 11:57:16 -0400
Message-ID: <4889F7D6.4010706@lwfinger.net>
Date: Fri, 25 Jul 2008 10:57:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: free_beer_for_all@yahoo.com
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: WLAN regression before this morning
References: <761713.15647.qm@web46115.mail.sp1.yahoo.com>
In-Reply-To: <761713.15647.qm@web46115.mail.sp1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

barry bouwsma wrote:
> Servus,
> 
> Last successfully built and used kernel was 2.6.26-rc8, about
> the start of 29.Jun UTC or so.
> 
> Present build of GIT 2.6.26 during the merge window, updated
> just before 06h UTC, today, 25.Jul.
> 
> With today's kernel, I am not even able to associate with a
> WLAN less than two metres away from my ZD1211rw type USB
> adapter, to say nothing of more distant WLANs with which I
> could authenticate with the earlier code without problems --
> I don't even come near the associate stage.
> 
> The networks all show up as expected in `iwlist wlan1 scan'
> with decent strengths; while all I get from dmesg is
> [ 1016.829827] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
> [ 1017.032769] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
> [ 1017.234213] wlan1: authenticate with AP 00:1X:YZ:AB:23:45
> [ 1017.435402] wlan1: authentication with AP 00:1X:YZ:AB:23:45 timed out
> 
> 
> If I've hosed myself with a new .config option, I'll be kicking
> meself where it hurts most.  Else, back to -rc8 to both send
> this message and to regain 'net access to do other needed so-
> called `work', so sorry I haven't narrowed this down further...
> 
> And I'll feel me a fool if the failure is because I went from
> a different (BSD) OS into 2.6.26-merge, while going from that
> into -rc8 I promptly associate as desired.

I too have a problem with wireless in the current 2.6.26-gitX kernels. If you 
have done the git pull, you can try bisecting to find the problem. Use 'git 
bisect good v2.6.26' to mark a known good point. If you don't wish to take the 
time bisecting, then issue a 'git checkout v2.6.26'. That should give you a 
kernel that works.

Larry
