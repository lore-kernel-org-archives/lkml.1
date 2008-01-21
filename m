Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYAUNAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYAUNAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 08:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYAUNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 08:00:06 -0500
Received: from pat.uio.no ([129.240.10.15]:48456 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbYAUNAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:00:05 -0500
Subject: Re: lockd spams syslog after upgrade from 2.6.18 to 2.6.24-rc8
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200801210003.35734.hpj@urpla.net>
References: <200801210003.35734.hpj@urpla.net>
Content-Type: text/plain
Date: Mon, 21 Jan 2008 08:00:00 -0500
Message-Id: <1200920400.11212.44.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 840BE41DAABD3011E1307FDDC776F9ABDEF8CBC2
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 3 total 6372112 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 00:03 +0100, Hans-Peter Jansen wrote:
> Hi, 
> 
> after installation of 2.6.24-rc8 on a local server, the syslog gets spammed 
> with "lockd: cannot monitor <some client>"
> 
> grep 'lockd: cannot monitor' /var/log/messages | wc -l
> 136026
> 
> in 20 minutes! I restarted the offending client (with 2.6.18.something) for 
> mercy reasons now..

It is telling you to either remount the NFS partition with the -onolock
option, or to start rpc.statd.

Trond

