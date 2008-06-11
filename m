Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbYFKUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbYFKUCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbYFKUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:02:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726AbYFKUCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:02:06 -0400
Date: Wed, 11 Jun 2008 13:01:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com
Subject: Re: [PATCH -mm 11/24] pageflag helpers for configed-out flags
Message-Id: <20080611130145.2a202339.akpm@linux-foundation.org>
In-Reply-To: <20080611184339.493423475@redhat.com>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.493423475@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008 14:42:25 -0400
Rik van Riel <riel@redhat.com> wrote:

> Define proper false/noop inline functions for noreclaim page
> flags when !defined(CONFIG_NORECLAIM_LRU)

I changed that to CONFIG_UNEVICTABLE_LRU.

Did we agree that the presence of this config variable is undesirable? 
If so, what's involved in making it go away?
