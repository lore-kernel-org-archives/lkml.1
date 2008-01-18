Return-Path: <linux-kernel-owner+w=401wt.eu-S1763291AbYARTrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763291AbYARTrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761247AbYARTrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:47:04 -0500
Received: from ozlabs.org ([203.10.76.45]:43431 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761365AbYARTrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:47:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: travis@sgi.com
Subject: Re: [PATCH 1/7] Modules: Fold percpu_modcopy into module.c
Date: Sat, 19 Jan 2008 06:46:25 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu, Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080118182953.748071000@sgi.com> <20080118182953.922370000@sgi.com>
In-Reply-To: <20080118182953.922370000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190646.25817.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 05:29:54 travis@sgi.com wrote:
> percpu_modcopy() is defined multiple times in arch files. However, the only
> user is module.c. Put a static definition into module.c and remove
> the definitions from the arch files.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
