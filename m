Return-Path: <linux-kernel-owner+w=401wt.eu-S940299AbXGaFtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940299AbXGaFtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbXGaFtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:49:04 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:46020 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXGaFtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:49:03 -0400
Message-ID: <46AECD48.1010701@nortel.com>
Date: Mon, 30 Jul 2007 23:48:56 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: trelane@digitasaru.net
CC: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk> <20070731034059.GF6812@digitasaru.net>
In-Reply-To: <20070731034059.GF6812@digitasaru.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2007 05:49:00.0162 (UTC) FILETIME=[7E286620:01C7D336]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joseph Pingenot wrote:

> While we're on the subject, is there some way to receive notification
>   that some aspect of a process changes (in this case, stopping using
>   CPU, but not exiting).

For some internal stuff a while back I did a patch that allows any 
process to register for status change notifications.  Basically, the 
registered process gets put on a list and gets the same notifications 
(killed/stopped/exited, etc.) as the real parent.

Useful for this type of thing.

Chris
