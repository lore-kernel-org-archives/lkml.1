Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbZKDDP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbZKDDP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZKDDPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:15:55 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59679 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZKDDPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:15:54 -0500
Date: Wed, 4 Nov 2009 12:15:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sh: Make sure indexes are positive
Message-ID: <20091104031540.GF12841@linux-sh.org>
References: <4AEF0572.9020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF0572.9020609@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 05:14:42PM +0100, Roel Kluin wrote:
> The indexes are signed, make sure they are not negative
> when we read array elements.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

In practice none of these are likely to be an issue, but it doesn't
really hurt to add the sanity checks given that there's already a number
of them anyways. So, applied.
