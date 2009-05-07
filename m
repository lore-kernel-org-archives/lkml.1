Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbZEGUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbZEGUQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZEGUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:16:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837AbZEGUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:16:00 -0400
Date: Thu, 7 May 2009 13:12:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@elte.hu, roland@redhat.com, vmayatsk@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] do_wait cleanupe (more to come)
Message-Id: <20090507131234.adf90d1b.akpm@linux-foundation.org>
In-Reply-To: <20090507064630.GA15847@redhat.com>
References: <20090507064630.GA15847@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 08:46:30 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Slightly tested. Definitely this needs more testing, but since a) the
> second patch was reviewed by Ingo and b) Andrew likes the buggy patches
> very much, I am sending this series. At least I believe this all is
> right "in general".

Worried.  This hits on ptrace and there's a lot of ptrace work pending,
including large changes which are threatening to come in via a different
tree (security).

If we end up with marginal/flakey patches in the middle of all of this,
a big mess ensues.

