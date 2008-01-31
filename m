Return-Path: <linux-kernel-owner+w=401wt.eu-S1763786AbYAaAOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763786AbYAaAOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYAaAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:14:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYAaAOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:14:07 -0500
Date: Wed, 30 Jan 2008 16:13:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/6] mm: bdi: tweak task dirty penalty
Message-Id: <20080130161352.4dae48e3.akpm@linux-foundation.org>
In-Reply-To: <20080129154947.110268504@szeredi.hu>
References: <20080129154900.145303789@szeredi.hu>
	<20080129154947.110268504@szeredi.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 16:49:01 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Penalizing heavy dirtiers with 1/8-th the total dirty limit might be rather
> excessive on large memory machines. Use sqrt to scale it sub-linearly.

Then again, it might not be.

I'll skip this one.  Please resend if/when it is proven to be a net benefit
across a broad range of workloads.  And stuff like that.
