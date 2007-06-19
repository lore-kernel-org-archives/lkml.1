Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbXFSTHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbXFSTHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXFSTGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:06:55 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:54236
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932351AbXFSTGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:06:53 -0400
Message-ID: <4678292B.6000804@hawkeye.stone.uk.eu.org>
Date: Tue, 19 Jun 2007 20:06:19 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com>
In-Reply-To: <46781A5B.9090104@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> But what you're talking about *will* break userspace.  If I do an ls in
> a directory, and get pages upon pages of versions of just one file,
> that's broken.  If I tar up a directory and get a tarball that's
> hundreds of times larger than it should be, that's broken.  If you want
> the files to be hidden from userspace applications that don't know about
> your backup scheme, (and it sounds like you do) then use the existing
> convention for hidden files, the prepended '.'  This is the universal
> sign for "don't mess with me unless you know what you're doing".

The idea was that if you did an ls you would get the latest version of
the file without the :revision_num. The only visible version would be
the latest version, i.e. the current system would not change. The idea
was that it would only show earlier versions if they were specifically
requested with a :revision_num suffix. In that case the
filesystem/kernel would need to recognise the suffix and return the
earlier version of the file.

The only userspace it would break is files with :num in their name, as I
haven't seen any files like that I don't think its too big a problem but
the way of specifiying revisions could be changed.

Jack
