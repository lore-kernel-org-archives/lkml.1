Return-Path: <linux-kernel-owner+w=401wt.eu-S972353AbXHMRQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972353AbXHMRQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S948252AbXHMRAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 13:00:55 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:56906 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030788AbXHMRAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 13:00:52 -0400
Date: Mon, 13 Aug 2007 18:58:21 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Karl Meyer <adhocrocker@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: PROBLEM: 2.6.23-rc "NETDEV WATCHDOG: eth0: transmit timed out"
Message-ID: <20070813165821.GA19356@electric-eye.fr.zoreil.com>
References: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be1b757c0708130435y689b9dd8raf9ac9f9c0fcc976@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(netdev Cced)

Karl Meyer <adhocrocker@gmail.com> :
[...]
> I am having trouble with the 2.6.23 kernel. With all versions since
> 2.6.23-rc1 I have trouble with my network connection. When using the
> network over a certain level (just browsing the web seems not to be
> enough) e.g. when installing packages over the nvsv4 share, all
> network stuff freezes for some time and syslog tells me:
> Aug 13 13:16:09 frege NETDEV WATCHDOG: eth0: transmit timed out
> Aug 13 13:16:39 frege NETDEV WATCHDOG: eth0: transmit timed out
> Aug 13 13:17:09 frege NETDEV WATCHDOG: eth0: transmit timed out
> Aug 13 13:17:57 frege NETDEV WATCHDOG: eth0: transmit timed out

Can you:
- send a complete dmesg + /proc/interrupts + .config
- use git bisect to find a suspect changeset
  I do not expect any change of behavior between 2.6.22 and
  25805dcf9d83098cf5492117ad2669cd14cc9b24 if it can help you narrow
  things down (assuming it is a r8169 regression).

-- 
Ueimor
