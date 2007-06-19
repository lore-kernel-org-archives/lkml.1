Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbXFSWOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbXFSWOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXFSWNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:13:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39591 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbXFSWNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:13:51 -0400
Message-ID: <4678550D.6070705@zytor.com>
Date: Tue, 19 Jun 2007 15:13:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: david@lang.hm
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Chris Snook <csnook@redhat.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <20070619204317.GR10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706191505130.26701@asgard.lang.hm>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> 
> the only trouble I ever had with the .snapshot approach is when tar or
> find would decend down into the .snapshot when I didn't really intend
> for it to do so.
> 

Netapp optionally made .snapshot not show up in readdir, which solved
that problem.

I have a bigger issue with it starting with only one dot, which is
traditionally used for user configuration information.  I think
..snapshot would have been a better choice, and by extension leaving
double-dot filenames as filesystem namespace (I know that contradicts
POSIX, but the only namespace available in POSIX is /../ which is a
global namespace.)

	-hpa
