Return-Path: <linux-kernel-owner+w=401wt.eu-S1758866AbZBMJau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866AbZBMJau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZBMJai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:30:38 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:24655 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZBMJag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:30:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=l2nsbB9yTiuFOm+OgN/bCGBfdrBW8VD0IUmDNs2LDX/hBIaKGPAMZSpQNUeDzAp0Ys
         ykAbPCZH5EvV0sqTpie8tY2VgZl8z+xN+5Tj30clZ6NEhELg3PeJBHtA4Ajmzhasnpxb
         wTIp8ALs/Wl8lejdcStI8amNEuSBpkQt8D+Hs=
MIME-Version: 1.0
In-Reply-To: <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>
	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>
	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>
Date: Fri, 13 Feb 2009 11:30:34 +0200
X-Google-Sender-Auth: ce2b06d1093e1523
Message-ID: <84144f020902130130k7d66bd0i7637ec0589d3bee1@mail.gmail.com>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
	64-bit
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 13, 2009 at 11:22 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> That sounds unfortunate. Can you post
>
>  cat /proc/meminfo | grep Slab
>
> results on sh without and with your patch? Bumping the limit up to
> ARCH_KMALLOC_MINALIGN does make sense but we'd need to know what kind
> of problems it might cause.

You probably want to fix up the issues Paul raised, though.
