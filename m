Return-Path: <linux-kernel-owner+w=401wt.eu-S1759452AbYA3WnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452AbYA3WnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYA3WnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:43:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571AbYA3WnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:43:07 -0500
Date: Wed, 30 Jan 2008 14:40:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: hugh@veritas.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       npiggin@suse.de, riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
Message-Id: <20080130144049.73596898.akpm@linux-foundation.org>
In-Reply-To: <1201714139.28547.237.camel@lappy>
References: <1201714139.28547.237.camel@lappy>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 18:28:59 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Implement MADV_WILLNEED for anonymous pages by walking the page tables and
> starting asynchonous swap cache reads for all encountered swap pages.

Why cannot this use (a perhaps suitably-modified) make_pages_present()?
