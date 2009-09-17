Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZIQMoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZIQMoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZIQMoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbZIQMob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:44:31 -0400
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 08:43:55 -0400
Message-Id: <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 23:36 -0400, Eric Paris wrote:
> Starting on Sept 14 linux-next became unbootable on my KVM guests.
> Latest I tried was linux-next as of today, Sept 16.  I spent the day
> today bisecting between next-20090911 and next-20090914 which was the
> last and first day linux-next broke.
> 
> My fedora 12 install gets to udev starting and then panics with the
> message:
> 
> Kernel panic - not syncing: Out of memory and no killable processes...

the next-20090916 tree still panic's the same way.  As does Linus'
latest git tree ab86e5765

I'll try bisecting between v2.6.31 and master if it would give better
data than trying to bisect between two -next trees, but I'm sorta stuck
with a machine that won't boot and doesn't tell me much about why.

-Eric

