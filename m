Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbXEGOsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbXEGOsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 10:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXEGOsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 10:48:39 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37073
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbXEGOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 10:48:38 -0400
Date: Mon, 7 May 2007 07:46:38 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Theodore Tso <tytso@mit.edu>
cc: Frank van Maarseveen <frankvm@frankvm.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: JBD: ext2online wants too many credits (744 > 256)
In-Reply-To: <20070507142736.GC17180@thunk.org>
Message-ID: <Pine.LNX.4.64.0705070744350.18013@asgard.lang.hm>
References: <20070506222626.GA25632@janus> <20070507142736.GC17180@thunk.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2007, Theodore Tso wrote:

> We're going to have to rethink the defaults of the journal size as it
> relates to on-line resizing, but there might not be a lot of great
> answers here.  We'll also have to look at the on-line resizing code
> and see if there's a way to break up the resize operation into smaller
> transactions as a way of avoiding this problem --- but that would
> still leave the user stuck with a pathetically small 4M journal on a
> 3G filesystem.

why not just allocate a new journal (something along the lines of convert 
the ext3 to ext2 then back to ext3 would be the ugly, scripted way of 
doing it)

or is the problem that you are trying to resize things without remounting 
them (and therefor without flushing the journal)

David Lang
