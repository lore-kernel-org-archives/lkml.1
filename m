Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZCEMZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZCEMZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZCEMZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:25:42 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:59372 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbZCEMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vdr7TPHD7BJEIRuIDmn0fm2WAnD8N/EP/FUoh9X1EBa+31mDGNyOh7ILAvRelaM1im
         NDi6/kEEyeVr89LxAqG6miRzieSVxYV4S5ieIiko9ZEdVPFqkvGYpgr5e868D+3cVceE
         Kh2oBq+1kSniJHxLHX4qmLU5P3bVEx2tZJi3E=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/3] ide-floppy: use ide_pio_bytes()
Date: Thu, 5 Mar 2009 13:27:49 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090304; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1236158216-23052-1-git-send-email-petkovbb@gmail.com> <1236158216-23052-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1236158216-23052-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903051327.49984.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 March 2009, Borislav Petkov wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> * Fix ide_init_sg_cmd() setup for non-fs requests.
> 
> * Convert ide_pc_intr() to use ide_pio_bytes() for floppy media.
> 
> * Remove no longer needed ide_io_buffers() and sg/sg_cnt fields
>   from struct ide_atapi_pc.
> 
> * Remove partial completions; kill idefloppy_update_buffers(), as a
>   result.
> 
> * Add some more debugging statements.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

thanks, applied 1-2
