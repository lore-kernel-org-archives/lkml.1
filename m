Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbYFNRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbYFNRsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbYFNRr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 13:47:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9214 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYFNRr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 13:47:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Yr2m/RwiLJ/vUo7E+WQ8TaUZG76kGUfk23D1ixaceMsWhml26UXrg8C9WzQKmreF1K
         7IIRBo8VEc+DIO7wg+vzhAns4OY69E2V+Ruw0xYGdUkGOyjUBwKvDUEIZGfnMJC+dYg0
         nnjsHJFzinMdB6JGkBbtQlP8La798BTDspux8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 18/18] ide: use flags in IRQ handler
Date: Sat, 14 Jun 2008 19:47:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-19-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1213252870-20474-19-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806141947.55580.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008, Borislav Petkov wrote:
> Pass pc->flags to the IRQ handler from the drivers (ide-tape/floppy/scsi) thus
> making it more pc-unaware.

This moves the problem around without improving the overall situation
w.r.t. pc->flags (now ATAPI drivers are more pc-aware instead).

It also adds one more argument to the already overloaded ide_pc_intr()
(my fault, I went a bit overboard but I added a nice TODO explanation! ;).

Since there are better ideas on how to deal with pc->flags (you've even
described them yourself in the first mail :) I skipped this patch for now.
