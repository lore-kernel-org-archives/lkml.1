Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZBEXvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZBEXvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbZBEXvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:51:17 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:37483 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753014AbZBEXvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:51:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=EsnwZVP+BNUYIpc85G6SuekBrUXQrUs5ob37Qe3uPsh7KKh8WKe2XUnhku9VzSzo15zsl7fT1MOYfTO9H7WgMqi0tTAaVA9XFwP/Pq1BrRDUxN1oUkWo4skYVwC3qKgh8jXk0NtwI5cDq0YqgpSBr87HpN31Brmeni3yjasSPng=  ;
X-YMail-OSG: stcfbucVM1nq7FwweFySE99kjuBeE9_yJ_CZuAaRmQCrVLVaAZarNDhPjxqypByg461E8Q33Rd9QR1niCv86cM6KwrslNUjkp_qLV6sGzltbNBT37q2W6xSpJWmjsARI4mtY3tgzBW_Ytgej9lHe0ot6Bu8N.GRFWk.j9HE_M62iz.5uMQOLQKB4FAFN
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 01/16] Blackfin SPI Driver: ensure cache coherency before  doing DMA
Date: Thu, 5 Feb 2009 15:51:13 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Vitja Makarov <vitja.makarov@gmail.com>
References: <1226994760-4301-1-git-send-email-cooloney@kernel.org> <200811201405.06811.david-b@pacbell.net> <386072610902050130k27c6d7far752ac49183bf36ae@mail.gmail.com>
In-Reply-To: <386072610902050130k27c6d7far752ac49183bf36ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051551.14146.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Bryan Wu wrote:
> As you acked this patchset, is that possible to merge it?
> Or need Andrew to keep them in -mm for a while.

ISTR *NOT* acking the whole series though.  In fact, I recall
giving a generic NAK part way through because of patches that
didn't include comments (after manually NAKing many individual
patches) and ones where $SUBJECT didn't match the patch comments.
Plus even a few which seemed to be wrong.

(And I've said the same thing about Blackfin patches before,
too.  Please help the message get through to your co-workers:
make sure the patches come with useful public descriptions.)

At this point, best to resend the whole series, with the
updates I requested.  The few patches which I did ack can
include that ack.

- Dave

