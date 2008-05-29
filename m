Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYE2Xmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYE2Xmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 19:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYE2Xmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 19:42:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975AbYE2Xmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 19:42:31 -0400
Date: Thu, 29 May 2008 16:36:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: shaggy@us.ibm.com, sandeen@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eCryptfs: Remove unnecessary page decrypt call
Message-Id: <20080529163643.4c2620fb.akpm@linux-foundation.org>
In-Reply-To: <20080529220817.GF7450@halcrowt61p.austin.ibm.com>
References: <20080529220817.GF7450@halcrowt61p.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 17:08:17 -0500
Michael Halcrow <mhalcrow@us.ibm.com> wrote:

> The page decrypt calls in ecryptfs_write() are both pointless and
> buggy.

buggy enough to be fixed in 2.6.26?  2.6.25.x?
