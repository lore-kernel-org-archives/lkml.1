Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZG0RG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZG0RG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZG0RG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:06:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38710 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZG0RG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:06:57 -0400
Date: Mon, 27 Jul 2009 10:06:58 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Greg KH <greg@kroah.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] ceph: debugfs
In-Reply-To: <20090725053107.GA20575@kroah.com>
Message-ID: <Pine.LNX.4.64.0907271006510.3707@cobra.newdream.net>
References: <1248292313-31326-10-git-send-email-sage@newdream.net>
 <1248292313-31326-11-git-send-email-sage@newdream.net>
 <1248292313-31326-12-git-send-email-sage@newdream.net>
 <1248292313-31326-13-git-send-email-sage@newdream.net>
 <1248292313-31326-14-git-send-email-sage@newdream.net>
 <1248292313-31326-15-git-send-email-sage@newdream.net>
 <1248292313-31326-16-git-send-email-sage@newdream.net>
 <1248292313-31326-17-git-send-email-sage@newdream.net>
 <1248292313-31326-18-git-send-email-sage@newdream.net>
 <1248292313-31326-19-git-send-email-sage@newdream.net> <20090725053107.GA20575@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009, Greg KH wrote:
> On Wed, Jul 22, 2009 at 12:51:52PM -0700, Sage Weil wrote:
> > Basic state information is available via /debug/ceph, including
> > instances of the client, fsids, current monitor, mds and osd maps,
> > outstanding server requests, and hooks to adjust debug levels.
> 
> debugfs is to be mounted at /sys/kernel/debug, not /debug  Please don't
> add any documentation or comments referring debugfs at /debug, we have
> just finally cleaned up all of these instances in the kernel right now.

Fixed, thanks!
sage
