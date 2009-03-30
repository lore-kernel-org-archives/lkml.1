Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZC3S26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZC3S26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756532AbZC3SRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:17:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34641 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655AbZC3SRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:17:34 -0400
Message-ID: <49D10CB7.7020805@redhat.com>
Date: Mon, 30 Mar 2009 14:17:27 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Simo Sorce <ssorce@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       john@johnmccutchan.com, rlove@rlove.org, Eric Paris <eparis@redhat.com>,
       Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] inotify: add hook to catch fsync/msync events
References: <1238434567.3597.31.camel@localhost.localdomain>
In-Reply-To: <1238434567.3597.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simo Sorce wrote:

> An external application that is interested to know if a database file has
> changed (in a meaningful way), would have no other way but to listen for
> IN_SYNC events.

Normal inotify tells the listener "something changed".

IN_SYNC tells the listeners "there is new, useful data".

Because this new inotify signal gives the listener more
useful information than the existing inotify paths, at
least for your use case, I believe the patch makes
perfect sense and should be merged.

> Signed-off-by: Simo Sorce <ssorce@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
