Return-Path: <linux-kernel-owner+w=401wt.eu-S1751457AbYBQR26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbYBQR26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYBQR2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:28:48 -0500
Received: from relay2.sgi.com ([192.48.171.30]:54709 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750700AbYBQR2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:28:48 -0500
Date: Sun, 17 Feb 2008 11:28:43 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: balbir@in.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7] CGroup API: Update cpusets to use cgroup
 structured file API
Message-Id: <20080217112843.5496412d.pj@sgi.com>
In-Reply-To: <6599ad830802170918q4c748f7fs32e5b8ea63e49f15@mail.gmail.com>
References: <20080215204418.535025000@menage.corp.google.com>
	<20080215204821.778088000@menage.corp.google.com>
	<20080216212901.70fe35ce.pj@sgi.com>
	<6599ad830802170918q4c748f7fs32e5b8ea63e49f15@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Strip all trailing whitespace (such as carriage returns)
> > when parsing integer writes to cgroup files, not just
> > one trailing newline if present.
> 
> Sounds like a good idea to me. Thanks for this.

I'm figuring it would be easiest if you just threw this
little change into your hopper for the bigger changes
you're making ... no need to preserve my name as author
of this.

But if you'd rather you or I send this separately to
Andrew Morton, that works too.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
