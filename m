Return-Path: <linux-kernel-owner+w=401wt.eu-S1765228AbYBNAv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765228AbYBNAv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933362AbYBNAvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:51:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46557 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933441AbYBNAvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:51:40 -0500
Date: Wed, 13 Feb 2008 16:50:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: sct@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH-resend] jbd/jbd2: sparse warnings in revoke.c, journal.c
Message-Id: <20080213165041.05955133.akpm@linux-foundation.org>
In-Reply-To: <1202949217.18204.32.camel@brick>
References: <1202949217.18204.32.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 16:33:37 -0800
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Subject: [PATCH-resend] jbd/jbd2: sparse warnings in revoke.c, journal.c

ext3/jbd and ext4/jbd2 patches usually find their way into the tree
via different routes, so bundling these two fixes was inappropriate.

General guidelines: one patch per subsystem and one patch per concept.

Sometimes those guidelines get bent, but only occasionally.  Usually
to avoid the silliness of handling a huge stream of one-line patches.
