Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYBJOU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYBJOU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYBJOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:20:48 -0500
Received: from hpsmtp-eml13.kpnxchange.com ([213.75.38.113]:20060 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035AbYBJOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:20:47 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
Date: Sun, 10 Feb 2008 15:20:45 +0100
User-Agent: KMail/1.9.7
References: <200802101440.22118.elendil@planet.nl>
In-Reply-To: <200802101440.22118.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101520.45296.elendil@planet.nl>
X-OriginalArrivalTime: 10 Feb 2008 14:20:45.0860 (UTC) FILETIME=[20519640:01C86BF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Frans Pop wrote:
> I have no idea yet what triggers it and am unsure if I'll be able to
> reproduce.

I think I know at least _when_ it happens: during compilation of glibc.

This was almost certainly while compiling in the normal amd64 environment:
> Pid: 2210, comm: ld-linux-x86-64 Not tainted 2.6.24 #1

And this was while compiling the glibc in an i386 unstable chroot:
> Pid: 29517, comm: ld-linux.so.2 Not tainted 2.6.24 #1

Could it be that some glibc unit test triggers this?

I have done one other compile of glibc yesterday though that did _not_ 
trigger the error, but that was using pbuilder (i.e. in an amd64 chroot).
