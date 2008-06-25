Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYFYAPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYFYAPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 20:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYFYAPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 20:15:08 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:13743 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYFYAPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 20:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Qa2BpKXP8aXZuXnRyislSBzMCV11IbytXYzeWNaERLD8yqR0DrL+yyNymrtigTVc44
         ik+w72tMIGNzka2TtaXmh1cXv1fwiey/YJ5TG2zITPF7+7dKyzG0GiL9d7lV9cUZ3QTP
         cZRRcJ30odUR558V99q8nErjvUfsBUsNAsAls=
Message-ID: <e9e943910806241715q25eebe91ie65044c34cbc5085@mail.gmail.com>
Date: Wed, 25 Jun 2008 01:15:04 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] ext3: handle deleting corrupted indirect blocks
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, sct@redhat.com,
       adilger@clusterfs.com, sliedes@cc.hut.fi
In-Reply-To: <20080624140551.567149b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080607121940.8ee6044a.akpm@linux-foundation.org>
	 <1214315240-22950-1-git-send-email-duaneg@dghda.com>
	 <20080624140551.567149b6.akpm@linux-foundation.org>
X-Google-Sender-Auth: e33e3715bbd11dfb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/24 Andrew Morton <akpm@linux-foundation.org>:
> Quite a few minorish ext3 fixes are coming in lately.  Is anyone
> checking whether they are needed in ext4 and if so, porting them
> over?

I was planning on doing my ones, once they'd gone through review and
been accepted into your tree. I'd be happy to do others too, if
needed.

> -mm's current queue is:
>
> ext3-fix-synchronization-of-quota-files-in-journal=data-mode.patch
> ext3-fix-typos-in-messages-and-comments-journalled-journaled.patch
> ext3-correct-mount-option-parsing-to-detect-when-quota-options-can-be-changed.patch

> jbd-replace-potentially-false-assertion-with-if-block.patch
> jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
> jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch

These three are mine and should have ext4 patches queued or upstream already.

> ext3-improve-some-code-in-rb-tree-part-of-dirc.patch
> jbd-fix-race-between-free-buffer-and-commit-trasanction.patch
> jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes.patch
> jbd-fix-race-between-free-buffer-and-commit-trasanction-checkpatch-fixes-fix.patch
> ext3-remove-double-definitions-of-xattr-macros.patch

> ext3-handle-corrupted-orphan-list-at-mount.patch
> ext3-handle-corrupted-orphan-list-at-mount-cleanup.patch
> ext3-handle-corrupted-orphan-list-at-mount-fix.patch
> ext3-handle-corrupted-orphan-list-at-mount-cleanup-fix.patch

These four are new ones from me. They don't have ext4 versions yet but
I'll prepare them soon.

> ext3-dont-read-inode-block-if-the-buffer-has-a-write-error.patch

> ext3-handle-deleting-corrupted-indirect-blocks.patch

Ditto this one.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
