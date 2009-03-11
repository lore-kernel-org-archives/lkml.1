Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZCKMcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZCKMcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZCKMby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:31:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:55110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZCKMbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:31:53 -0400
Date: Wed, 11 Mar 2009 13:31:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Paul Collins <paul@burly.ondioline.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hid/apple: add module parameter to swap Command and
 Option keys
In-Reply-To: <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
Message-ID: <alpine.LRH.2.00.0903111329170.26691@twin.jikos.cz>
References: <49B19FF3.2000605@gmail.com> <1236398835-8211-1-git-send-email-paul@burly.ondioline.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Mar 2009, Paul Collins wrote:

> Apple keyboards have the Command keys (a.k.a. the Apple or "waffle" key) 
> in the positions normally occupied on PC keyboards by the Alt/AltGr 
> keys, and the Option or Alt keys in the position occupied by the 
> so-called Windows keys.  Folks who have been using PC-type computers for 
> too long generally have insurmountable muscle memory in this regard.
> This patch adds a module parameter, defaulting to off, that swaps these keys.

Hi Paul,

as this looks like "usability" thing (i.e. nothing that would be implied 
by the actual hardware design), wouldn't it make more sense to do the 
remapping from userspace using EVIOCSKEYCODE ioctl()? HID devices support 
it for quite some time already.

There are various tools to do this in a user-friendly way. Keytouch, to 
pick one -- http://keytouch.sourceforge.net/

-- 
Jiri Kosina
SUSE Labs

