Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZHDCzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZHDCzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 22:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZHDCzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 22:55:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46017 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZHDCzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 22:55:14 -0400
Date: Mon, 3 Aug 2009 22:55:12 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drop superfluous casts in nr_free_pages() callers
Message-ID: <20090804025512.GH28572@bombadil.infradead.org>
References: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:11:42PM +0200, Geert Uytterhoeven wrote:
> Commit 96177299416dbccb73b54e6b344260154a445375 ("Drop free_pages()")
> modified nr_free_pages() to return 'unsigned long' instead of 'unsigned int'.
> This made the casts to 'unsigned long' in most callers superfluous, hence
> remove them.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Kyle McMartin <kyle@mcmartin.ca>
