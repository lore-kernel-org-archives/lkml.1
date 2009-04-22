Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZDVQFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZDVQFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 12:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZDVQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 12:05:04 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:54935 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZDVQFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 12:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <1240331881-28218-13-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> 
	<1240331881-28218-13-git-send-email-tj@kernel.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 22 Apr 2009 10:04:47 -0600
Message-ID: <fa686aa40904220904x1691da53n86fdd49bdb600553@mail.gmail.com>
Subject: Re: [PATCH 12/14] block: replace end_request() with 
	[__]blk_end_request_cur()
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       Joerg Dorchain <joerg@dorchain.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>, Tim Waugh <tim@cyberelk.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Paul Mackerras <paulus@samba.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Laurent Vivier <Laurent@lvivier.info>, unsik Kim <donari75@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:37 AM, Tejun Heo <tj@kernel.org> wrote:
> end_request() has been kept around for backward compatibility;
> however, it's about time for it to go away.
[...]
>  drivers/block/xsysace.c         |    4 +-

Acked-by: Grant Likely <grant.likely@secretlab.ca>
