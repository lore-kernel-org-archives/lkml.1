Return-Path: <linux-kernel-owner+w=401wt.eu-S932376AbYAaK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbYAaK2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbYAaK1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:27:53 -0500
Received: from sacred.ru ([62.205.161.221]:55087 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbYAaK1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:27:52 -0500
Message-ID: <47A1A29B.9000509@openvz.org>
Date: Thu, 31 Jan 2008 13:27:39 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>, "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Denis Lunev <den@openvz.org>
Subject: Re: Strange commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
References: <20080130175508.GC29368@does.not.exist>
In-Reply-To: <20080130175508.GC29368@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 31 Jan 2008 13:27:23 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Commit 42a73808ed4f30b739eb52bcbb33a02fe62ceef5
> ("[RAW]: Consolidate proc interface.") did not only change raw6_seq_ops
> (including adding 3 EXPORT_SYMBOL_GPL's to net/ipv4/raw.c for accessing 
> functions from there), it also removed the only user of raw6_seq_ops...

The commit is not strange it is wrong :( Sorry David, when I checked
the according proc files, I saw that both files show sockets, but
overlooked that the raw6 one shows the ipv4 part of the ipv6 socket.

Denis noticed that this morning and has already prepared a fix.
So please, do not revert the commit, the fix will be at your mailbox today.

Thanks, Adrian.

> cu
> Adrian
> 

