Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYIVXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYIVXhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbYIVXhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:37:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbYIVXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:37:24 -0400
Date: Mon, 22 Sep 2008 16:36:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Only register notifiers when the braille console is
 used.
Message-Id: <20080922163621.a9f001ab.akpm@linux-foundation.org>
In-Reply-To: <20080922214031.GJ5930@implementation>
References: <20080922214031.GJ5930@implementation>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 23:40:31 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Only register the braille driver VT and keyboard notifiers when the
> braille console is used.  Avoids eating insert or backspace keys.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11242
> 
> Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

I have a suspision from your signoff trail that Pascal actually authored
this patch.  Is that correct?

If so, the authorship should have been tracked by putting his From:
line right at the top of the changelog.

Thanks.
