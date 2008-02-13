Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbYBMQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbYBMQgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933266AbYBMQfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:35:39 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:33871 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265AbYBMQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:35:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SPN3r21FJf3QgwbQL0cncLCW0HeDjhJg/3SJQiZDHv1YMCTVh6NqHc24zQTjw2B51Llt3LgHDmoRFc5NoSFTOXWAhNZI7lJ5STqWHGS770GxH2YrJGnK2f8ylC1YpeCF0EQo7ES5QWfDAJqW7UBZL0MjIxfoVZ2ObKJzPc5CuO4=
Message-ID: <58cb370e0802130835p242386fcj815649c9c33f43f4@mail.gmail.com>
Date: Wed, 13 Feb 2008 17:35:34 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Borislav Petkov" <petkovbb@googlemail.com>
Subject: Re: [PATCH 1/2] ide: use generic ATAPI packet command flags in ide-{floppy,tape,scsi}
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Borislav Petkov" <petkovbb@gmail.com>
In-Reply-To: <1202919531-17798-1-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202919531-17798-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 13, 2008 5:18 PM, Borislav Petkov <petkovbb@googlemail.com> wrote:
> This is done in one single patch in order not to cause git breakage.
>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

Looks good but could you please reorder patches and move PC_* -> PC_FLAG *
rename in ide-scsi to the patch removing atomic bitops from ide-scsi?

Thanks,
Bart
