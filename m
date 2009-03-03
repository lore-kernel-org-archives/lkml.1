Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZCCDaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZCCDaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZCCDaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:30:07 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:40681 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZCCDaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:30:06 -0500
Message-ID: <49ACA433.5050400@davidnewall.com>
Date: Tue, 03 Mar 2009 13:59:55 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Failover Kernel
References: <49A659D0.2040903@turknet.net.tr>	 <200902261802.56612.diegocg@gmail.com>  <49A80796.2070208@turknet.net.tr> <1235749850.4718.1.camel@localhost.localdomain> <49AC0799.5060306@turknet.net.tr>
In-Reply-To: <49AC0799.5060306@turknet.net.tr>
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> the point is not to make boot when crash occured. The idea is to take
> control when a crash occured by backup kernel without any need to reboot.

It sounds like you want everything to just continue running.  I don't
see how that can be done.  All of those in-kernel tables and structures
would need to be migrated, and it follows, because there was a crash,
that any of them might have been corrupted.  Worse, you want this to
save you when you try running a new kernel which crashes, and being a
new kernel, it follows that any of those structures could be different;
it might not be possible to create equivalent structures for different
kernel versions.

If you're at all concerned at keeping the computer running, and I think
that's your goal, then I think the best you can do is reset the
hardware, boot an alternate kernel and restart applications as appropriate.
