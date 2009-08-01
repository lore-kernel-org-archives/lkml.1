Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZHAHrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZHAHrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZHAHrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:47:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48900 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZHAHrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=NN7w1ujZEV/6OvwcNLnf44BqAVgtGdqSO+Y3A6teH+wA+Lexu2OrirGRKisyZweBF2
         75NqeGyNcsxM7aSF+9bagFidxg2vPS7KmyRtwzT8bqoXSzRfLg/D1KKCCYOthBVp/6tl
         obXVkIs3IuAiiAyWbrNL+wxn+KNdo3t2yPQcE=
Date: Sat, 1 Aug 2009 09:47:27 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Nicolas Palix <npalix@diku.dk>
Cc: x86@kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, borislav.petkov@amd.com
Subject: Re: [PATCH] Fix compilation error in amd.c when SMP is not set
Message-ID: <20090801074727.GB26095@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Nicolas Palix <npalix@diku.dk>, x86@kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org, borislav.petkov@amd.com
References: <200907311640.25585.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200907311640.25585.npalix@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 04:40:25PM +0200, Nicolas Palix wrote:
> The function amd_fixup_dcm requires SMP to be set
> but it is called only when CONFIG_X86_HT is set.
> 
> It thus defined only if CONFIG_X86_HT is set.
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>

Thanks, I'll integrate it into the original patch:
29160dfe027e90532bd60a97db1dd158d996be8b.

-- 
Regards/Gruss,
    Boris.
