Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZBWXE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZBWXE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZBWXEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:04:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbZBWXEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:04:49 -0500
Date: Mon, 23 Feb 2009 15:04:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: mike@compulab.co.il, linux-kernel@vger.kernel.org
Subject: Re: checkpatch --file warns about p0 patch
Message-Id: <20090223150405.ce90a2c0.akpm@linux-foundation.org>
In-Reply-To: <20090223144312.GC22617@shadowen.org>
References: <49A2B0A5.8050905@compulab.co.il>
	<20090223144312.GC22617@shadowen.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 14:43:12 +0000
Andy Whitcroft <apw@canonical.com> wrote:

> Hmm, that should already be fixed in the version Andrew Morton has.

Hmm, all of these:

checkpatch-make-in_atomic-ok-in-the-core.patch
checkpatch-do-not-warn-about-p0-patches-when-checking-files.patch
checkpatch-correctly-handle-type-spacing-in-the-face-of-modifiers.patch
checkpatch-pointer-type-star-may-have-modifiers-following.patch
checkpatch-a-modifier-is-not-an-identifier-at-the-end-of-a-type.patch
checkpatch-extend-attribute-testing-to-all-modifiers.patch
checkpatch-add-__ref-as-a-sparse-modifier.patch
checkpatch-version-028.patch

apart from perhaps checkpatch-add-__ref-as-a-sparse-modifier.patch look
like bugfixes.  So I suppose we should slip them into 2.6.29, yes?

