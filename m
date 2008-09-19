Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYISHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYISHMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYISHMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:12:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:9125 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYISHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=foXIaStNN96jejVwbwnL0/tNEg7NrZneYTxmdYt2/oMILG/kEIzX2MzSnmmGHcAtpQ
         k6sLm/2EOZEGaRkRA95zE5mmZGWNfAThNUO2g/MFSy4qU35xdN99y5INMTgKNbVT0fNS
         rA7g1+9BIm5RHfm1cMKk+PaIvSa8cBrKMQTDo=
Message-ID: <84144f020809190012u1b7dd266q3d2f689b4c2cfdf9@mail.gmail.com>
Date: Fri, 19 Sep 2008 10:12:03 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 1/4] Make the per cpu reserve configurable
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
In-Reply-To: <20080918233701.127757960@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080918233648.581696416@quilx.com>
	 <20080918233701.127757960@quilx.com>
X-Google-Sender-Auth: a795661c073a820a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Sep 19, 2008 at 2:36 AM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> The per cpu reserve from which loadable modules allocate their percpu sections
> is currently fixed at 8000 bytes.
>
> Add a new kernel parameter
>
>        percpu=<dynamically allocatable percpu bytes>
>
> The per cpu reserve area will be used in following patches by the
> per cpu allocator.
>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
>
> ---
>  arch/ia64/include/asm/percpu.h |    1 +
>  include/linux/percpu.h         |    7 ++++++-
>  init/main.c                    |   13 +++++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)

Wrong diffstat? There's no ia64 changes in the patch.
