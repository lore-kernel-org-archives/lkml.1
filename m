Return-Path: <linux-kernel-owner+w=401wt.eu-S1761212AbYCUACa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212AbYCUACa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759320AbYCTX5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:57:01 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:57106 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbYCTX4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Q+09iKlO2dw5QiQovg6o4SrDeLI8F24OLFQVOtDxeLmxGobz7rjNaa9v/gJuNbEl4adXkzWqgoiP9pSLaYKyAIV9HbLJ68WoEh0382qtlzXH5z7rTOFfCCIZAbL38p7D3O68zdwDiaOkCBiawzvphF6e6n6vNLYA6ofiTl/FYnw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 09/17] ide-tape: unwrap idetape_queue_pc_tail()
Date: Fri, 21 Mar 2008 01:09:35 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-10-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-10-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.35637.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> idetape_queue_pc_tail() is a wrapper for its __idetape_queue_pc_tail() counterpart
> and has no other functionality. Remove it and call the "wrapped" function
> directly.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied
