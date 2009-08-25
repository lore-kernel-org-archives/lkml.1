Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZHYR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZHYR25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbZHYR25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbZHYR24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:28:56 -0400
Message-ID: <4A941F56.8060502@redhat.com>
Date: Tue, 25 Aug 2009 13:28:54 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Jeff Shanab <jshanab@earthlink.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Starting a grad project that may change kernel VFS. Early 	research
 Re: Starting a grad project that may change kernel VFS. Early 	research
References: <4A93428A.4070903@earthlink.net>
In-Reply-To: <4A93428A.4070903@earthlink.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Shanab wrote:

> Updates start at the file and only work upwards back to root. How does
> the hardlink get traversed?

A hard link is just a second directory entry linking to
the same inode.  There are no back links from inodes to
the directory entries that point to them and they are
essentially indistinguishable from files that are not
hardlinked.

Hard links have been done like this in pretty much every
Unix filesystem since the 1970's.

-- 
All rights reversed.
