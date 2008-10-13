Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYJMPDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYJMPDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 11:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYJMPCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 11:02:50 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:39772 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbYJMPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 11:02:49 -0400
Message-ID: <48F36311.5030303@motion-twin.com>
Date: Mon, 13 Oct 2008 17:02:41 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: recv() hangs until SIGCHLD ?
References: <48EF58D9.6060401@motion-twin.com> <20081010211700.58e953a2@speedy> <48F063C5.3000707@motion-twin.com> <48F30772.7040207@motion-twin.com>
In-Reply-To: <48F30772.7040207@motion-twin.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Cannasse a écrit :
>>> If there is data and the thread didn't wake up then that is a libc or 
>>> kernel problem;
>>> but if there is no data, then look for cases where earlier 
>>> interrupted io actually
>>> consumed the data already or blame the sending process not the receiver.
>>> Also are the sockets blocking or non-blocking?

One other thing :

We tried to use a poll(POLLIN) on the socket before entering the recv(). 
The poll() does exit (and we are looping in case of EINTR result) but 
after that recv() blocks infinitely.

Hope that helps,

Nicolas

