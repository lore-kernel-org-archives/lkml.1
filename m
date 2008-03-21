Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYCTX6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYCTX6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbYCTX4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbYCTX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ik+BVmjByWJzP0oOcXWN+ZO6RPaWDk7jeyUHOAd5T8+pEeEORNzKzTEoSMbwhvxxeT6l3GfQKaF0ziRdEGzoe7ClzRXW8HM83OgPHOBLZ5sPELwZt2foh1uAteqXNb6cxId75142/205mWz3xRfJLaC+VzacJqC133b6RiwBF7s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 06/17] ide-tape: remove idetape_pipeline_size()
Date: Fri, 21 Mar 2008 01:09:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-7-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-7-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.26119.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> The computation of the block offset of the the tape position (MTIOCPOS,
> MTIOCGET) is not influenced by the stages queued in the pipeline anymore but by
> the size of the current buffer which is going to be sent to the drive.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied

[ I resurrected deleted idetape_wait_for_pipeline() call ]
