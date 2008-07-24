Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYGXA1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYGXA1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbYGXA0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:26:50 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:46316 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbYGXA0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DbWTRTiARHB1++naN9tMcoM8TRImt4j0wAWUAFsvJypJb2XQ4iIcqJ1Wg+DQVS/dHW
         hB1hs6/ACXR1uTfD+00ygu2kIUFsQSp2ILArhcY16QATWvOxfmj82MrVd6l8aE7LROxV
         XDnTbAiy/sqfdTFqbvFlYNOoZm5jO4zTgKdak=
Message-ID: <524f69650807231726l40641b7ai2fb7529b3319893b@mail.gmail.com>
Date: Wed, 23 Jul 2008 19:26:47 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH] cifs: avoid mixing bool and le16
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1216859051.30386.40.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216857138.30386.33.camel@brick>
	 <524f69650807231719y33e96d02y7b04d1115620aa1d@mail.gmail.com>
	 <1216859051.30386.40.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 7:24 PM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> On Wed, 2008-07-23 at 19:19 -0500, Steve French wrote:
> Would you prefer:
>        if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
>                is_unicode = true;
>        else
>                is_unicode = false;
>
> Instead?

Yes   :)



-- 
Thanks,

Steve
