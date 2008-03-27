Return-Path: <linux-kernel-owner+w=401wt.eu-S1760060AbYC0NhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760060AbYC0NhP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 09:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbYC0NhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 09:37:02 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:53796 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYC0NhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 09:37:00 -0400
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 20/26] UBIFS: add VFS operations
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	<1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2008 14:36:56 +0100
In-Reply-To: <1206629746-4298-21-git-send-email-Artem.Bityutskiy@nokia.com>
Message-ID: <87bq50jnk7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Mar 2008 13:30:19.0066 (UTC) FILETIME=[B335F9A0:01C8900E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <Artem.Bityutskiy@nokia.com> writes:

(haven't read the whole thing) 

> +		inode->i_gid = current->fsgid;
> +	inode->i_mode = mode;
> +	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;

Any specific reason you didn't implement sub second time stamp support?
There is really no good excuse to not do that on a new file system.

-Andi
