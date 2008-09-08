Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbYIHAzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbYIHAzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYIHAzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:55:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbYIHAzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:55:08 -0400
Date: Sun, 7 Sep 2008 20:55:36 -0400
From: Rik van Riel <riel@redhat.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
Message-ID: <20080907205536.0d1937ff@riellaptop.surriel.com>
In-Reply-To: <48C471AE.8060809@acm.org>
References: <48BFCECE.90103@gmail.com>
	<87iqtbuez9.fsf@basil.nowhere.org>
	<48C19648.8030002@gmail.com>
	<20080905194501.GZ18288@one.firstfloor.org>
	<20080906014214.22f28548@riellaptop.surriel.com>
	<48C471AE.8060809@acm.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Sep 2008 18:28:30 -0600
Zan Lynx <zlynx@acm.org> wrote:
> Rik van Riel wrote:
> [cut]
> > On the other hand, you do want to avoid evicting data 
> > that the process is still using, just because you are 
> > swapping out a not recently referenced page on a
> > nearby virtual address.
> 
> How about writing the nearby pages to swap anyway and mark the still 
> in-use pages as SwapCache.

That is what will happen pretty much automatically.

Another thing the swap out page clustering code could
do is move pages that were recently referenced back
to the active list, so the VM will not have to scan
those pages again.

-- 
All rights reversed.
