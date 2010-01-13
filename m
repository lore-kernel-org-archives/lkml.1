Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605Ab0AMWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0AMWGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594Ab0AMWGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:06:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab0AMWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:06:39 -0500
To: Alexander Shishkin <virtuoso@slind.org>
Cc: Valdis.Kletnieks@vt.edu, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC][PATCHv3] List per-process file descriptor consumption when hitting file-max
From: Andi Kleen <andi@firstfloor.org>
References: <28675.1248957636@turing-police.cc.vt.edu>
	<1263202687-18529-1-git-send-email-virtuoso@slind.org>
Date: Wed, 13 Jan 2010 23:06:37 +0100
In-Reply-To: <1263202687-18529-1-git-send-email-virtuoso@slind.org> (Alexander Shishkin's message of "Mon, 11 Jan 2010 11:38:07 +0200")
Message-ID: <87pr5dfymq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shishkin <virtuoso@slind.org> writes:

> When a file descriptor limit is hit, display the top consumers of
> descriptors so that it is possible to identify and fix those which
> leak them.

Can't you get that information from /proc/*/fd/ ? 

Doing it in user space would be much saner.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
