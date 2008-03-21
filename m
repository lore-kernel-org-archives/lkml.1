Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbYCTX71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbYCTX71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYCTX4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:63287 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbYCTX4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=m0lgdNrcJqus+wquGy5a+e1LvVUJ9LyJDNB0Z6SDgEz07TQnmVuTXxBbxCJdvkiJYVhW4mx8iyS4WDKouqSow3cgQRMu0khjiikj4a7/Y1rvR2Rc11ls0SwS1hiEbIQyXCgtcKlx/aRQQbZyXFcsIbmF7Fa65GZjjmKGAITiXO4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 10/17] ide-tape: remove remaining pipeline functionality
Date: Fri, 21 Mar 2008 01:09:38 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-11-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-11-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.38671.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> The driver is using now solely its own request queue.

patch summary and patch description are _very_ sparse

[ at least two things are worth mentioning here:

  - tape->next_stage is always NULL so it is safe to remove
    all code depending on tape->next_stage != NULL

  - this patch removes the last place which sets
    IDETAPE_FLAG_PIPELINE_ACTIVE in tape->flags ]

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
