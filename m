Return-Path: <linux-kernel-owner+w=401wt.eu-S1030858AbXDXAXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030858AbXDXAXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 20:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030894AbXDXAXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 20:23:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030858AbXDXAXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 20:23:17 -0400
Message-ID: <462D4D6E.50809@zytor.com>
Date: Mon, 23 Apr 2007 17:21:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Theodore Tso <tytso@mit.edu>, Eric Hopper <hopper@omnifarious.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
References: <462C2E5B.1080008@redhat.com>	<Pine.LNX.4.64.0704230353000.25153@server.thyself>	<462C4858.3050006@redhat.com>	<Pine.LNX.4.64.0704230555020.25153@server.thyself>	<462C4D32.4000909@redhat.com>	<Pine.LNX.4.64.0704230611430.25153@server.thyself>	<462C5034.9090403@redhat.com>	<Pine.LNX.4.64.0704230640540.25153@server.thyself>	<20070423010445.454eda63.akpm@linux-foundation.org>	<20070423135216.GA2744@omnifarious.org>	<20070423225640.GA1663@thunk.org>	<462D46DF.4090802@zytor.com> <17965.19438.292138.959036@notabene.brown>
In-Reply-To: <17965.19438.292138.959036@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> 
> Our you could think outside the circle:
> Store all your "small files" as symlinks, then use "symlink" to create
> them and "readlink" to read them. (You would probably end up use
> symlinkat and readlinkat).
> Only one system call instead of three.
> I guess you don't get meaningful permission bits then... I wonder if
> that really matters.
> 

For some applications, oh yes it does.

	-hpa
