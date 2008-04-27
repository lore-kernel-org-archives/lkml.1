Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYD0NyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYD0NyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 09:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbYD0NyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 09:54:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:2768 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYD0NyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 09:54:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fduVTZJJhTw5sr9Gqbr2J/Z3o2hfz+j6IXDuP+asrEi6qOBPRQ6byEKdnd139cGmL25y27aZu8fSDIE5qHMunziXJvERnfgCIPCfV7Vh19wDimbeynwEWSZYiAW9ldPbuX2YFzwR/QK3Sui2I4zMywN1jcHC5ITjVxM5ztl3ssw=
Message-ID: <386072610804270653vdfd2cf3g30a07ee41d6e9c0d@mail.gmail.com>
Date: Sun, 27 Apr 2008 21:53:58 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [libata/BF54x]: Fix bug - Implement bfin ata interrupt handler to avoid "irq 68 nobody cared" (v2)
Cc: "Sonic Zhang" <sonic.zhang@analog.com>, "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <1209115165-24995-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209115165-24995-1-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: d6c6b493d3f10507
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 5:19 PM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
>  Return IRQ_HANDLED when bfin ata device is busy.
>  http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=3513
>
>  v1-v2:
>   - fold api breakage fixing patch together.
>   - mark 'static', not 'inline'.
>
>  Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>  Signed-off-by: Bryan Wu <cooloney@kernel.org>
>  ---
>   drivers/ata/pata_bf54x.c |  124 ++++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 120 insertions(+), 4 deletions(-)
>

Hi Jeff,

Is this V2 updated patch OK for you?

Thanks
-Bryan
