Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYLCAk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYLCAk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 19:40:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYLCAkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 19:40:47 -0500
Received: from metal.x2a.org ([206.248.189.157]:39938 "EHLO metal.x2a.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbYLCAkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 19:40:46 -0500
Message-ID: <4935D58B.4020002@x2a.org>
Date: Tue, 02 Dec 2008 19:40:43 -0500
From: Jonathan Bastien-Filiatrault <joe@x2a.org>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Andres Freund <andres@anarazel.de>,
       Andreas Dilger <adilger@sun.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: EXT4 ENOSPC Bug
References: <200811291418.24672.andres@anarazel.de> <200812021559.05103.andres@anarazel.de> <20081202164709.GC18162@mit.edu> <200812021847.35771.andres@anarazel.de> <20081202203315.GA20858@mit.edu> <4935D4C0.7050601@x2a.org>
In-Reply-To: <4935D4C0.7050601@x2a.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Bastien-Filiatrault wrote:
> Theodore Tso wrote:
> 
>> Hmm...  really?  Was the error message ENOSPC, or something else?
>>
> I can confirm I get a ENOSPC on open/creat. Here is the relevant output
> from strace touch test:
> 
(Sorry for replying to myself)

This happened while compiling a kernel with ccache enabled (with a
relatively low hit rate for this specific build). Vuze was also opened,
but with no active download.

Cheers,
Jonathan
