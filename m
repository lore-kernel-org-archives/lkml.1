Return-Path: <linux-kernel-owner+w=401wt.eu-S1760385AbZACVRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385AbZACVRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZACVRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:17:16 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:59562 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbZACVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:17:16 -0500
Message-ID: <495FD5D7.2040907@ribosome.natur.cuni.cz>
Date: Sat, 03 Jan 2009 22:17:11 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       tytso@mit.edu, mtk.manpages@gmail.com, rdunlap@xenotime.net,
       linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
References: <20090103123813.GA1512@ucw.cz>
In-Reply-To: <20090103123813.GA1512@ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can one avoid replay of the journal then if it would be unclean?
Just curious.
M.

Pavel Machek wrote:
> Using ext3 is only safe if storage subsystem meets certain
> criteria. Document those.
> 
> Errors=remount-ro is documented as default, but superblock setting
> overrides that and mkfs defaults to errors=continue... so the default
> is errors=continue in practice.
> 
> readonly mount does actually write to the media in some cases. Document that.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
