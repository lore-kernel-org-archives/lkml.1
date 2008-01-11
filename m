Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYAKOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYAKOVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbYAKOV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:21:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:55408 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYAKOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:21:28 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFD] Incremental fsck
To: Al Boldi <a1426z@gawab.com>, Valerie Henson <val.henson@gmail.com>,
       Rik van Riel <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 11 Jan 2008 15:20:33 +0100
References: <9JubJ-5mo-57@gated-at.bofh.it> <9JB3e-85S-13@gated-at.bofh.it> <9JDRm-4bR-1@gated-at.bofh.it> <9JHLl-2dL-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JDKkM-0003dY-1b@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19IZBShT20v3SBiMo/+KoZ0otwApNAPCGtsNmd
 TEQfAEQsdU5TQcloKdQz4Tg0IiLQXrr1i9ezdEjPPUgNpAT8J3
 XtDiaeBoDjWaTkkxI6XXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi <a1426z@gawab.com> wrote:

> Even after a black-out shutdown, the corruption is pretty minimal, using
> ext3fs at least.  So let's take advantage of this fact and do an optimistic
> fsck, to assure integrity per-dir, and assume no external corruption.  Then
> we release this checked dir to the wild (optionally ro), and check the next.
> Once we find external inconsistencies we either fix it unconditionally,
> based on some preconfigured actions, or present the user with options.

Maybe we can know the changes that need to be done in order to fix the
filesystem. Let's record this information in - eh - let's call it a journal!

