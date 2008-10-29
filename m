Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYJ2Xxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYJ2Xxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYJ2Xx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:53:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48571 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYJ2XxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:53:25 -0400
To: rjw@sisk.pl
CC: ncunningham@crca.org.au, stern@rowland.harvard.edu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <200810292307.26945.rjw@sisk.pl>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
References: <Pine.LNX.4.44L0.0810291627040.3986-100000@iolanthe.rowland.org> <200810292211.49021.rjw@sisk.pl> <1225316715.18786.1.camel@nigel-laptop> <200810292307.26945.rjw@sisk.pl>
Message-Id: <E1KvKql-0000dC-3M@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 30 Oct 2008 00:53:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Rafael J. Wysocki wrote:
> In any case, the freezing of user space seems to be much simpler
> than modifying all drivers to add suspend synchronization.

As I mentioned, we don't _have_ to modify all drivers.  It could start
out by just modifying syscalls that result in calls to drivers.  That
would be a 10-liner patch.

Miklos
