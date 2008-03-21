Return-Path: <linux-kernel-owner+w=401wt.eu-S1759532AbYCTX7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759532AbYCTX7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbYCTX4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbYCTX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=aoPt7tyDkmx1SAvn7C6HgX4Gg4tt4+QNj2uhGD6tn6kZXHJozukKVU/mgrpY0aRi60YRT6/pVVw9G60I1Yeyia6V5QC4ZGeV5h5X2s/22qZn+u+g1BEkpn6G7LvW+yU5+1Vpe2t/z46WTH4HyxxER5K2ULb3HtPKWdGtDaJGzns=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 08/17] ide-tape: remove pipeline-specific code from idetape_end_request()
Date: Fri, 21 Mar 2008 01:09:31 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-9-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-9-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.31169.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> As a side effect, remove unused idetape_kfree_stage() and
> idetape_abort_pipeline()
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied

[ I resurrected taking tape->lock + clearing IDETAPE_FLAG_PIPELINE_ACTIVE ]
