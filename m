Return-Path: <linux-kernel-owner+w=401wt.eu-S965203AbYD1QC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965203AbYD1QC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbYD1QCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:02:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45097 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbYD1QCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=qCeVyMMKOPGuJsfoWU+HrEPgm8MTZjovSVhqaAtJxDIGIxCQn9X9yONT3cWMETPjsTSj8ge1MKqcDfHv0jhpigxCcQC4ZS4GhuqIp1WifAaYam6AM+dL4urRPLVGt9bj7V/mLBjyBt20mNTO2Bp1KiVsSdFwWvMVEtrdxeKaGNs=
Message-ID: <4815F4F6.1030708@googlemail.com>
Date: Mon, 28 Apr 2008 18:01:58 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mika Fischer <mika.fischer@zoopnet.de>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
   layout v2
References: <200804272337.40130.yhlu.kernel@gmail.com>	<200804280206.52641.yhlu.kernel@gmail.com>	<20080428130826.GH27997@elte.hu> <20080428064925.318659b9@laptopd505.fenrus.org> <4815ED15.3080702@zoopnet.de>
In-Reply-To: <4815ED15.3080702@zoopnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Fischer wrote:
>>> how relevant is this feature with modern Xorg? I thought modern Xorg 
>>> would get its mappings via /sys, hence it would not have to touch
>>> MTRRs at all.
>> that's true for current X, but not for 6 month old X :=(
> 
> Ah, so the new X will be able to use the video memory in write-combining
> mode even if I have an MTRR saying this area is uncachable or write-back?
> 
> If that is the case, then I agree that this patch is not really needed.

I doubt there will be any usable Xorg release soon.
And I doubt peoples will run Xorg , mesa , etc master HEAD to have that feature. 

I think this patch is needed for now but as Ingo said , it should not be default.
Peoples with these sort problems could boot with some option to enables this workaround.

Just my opinion.

> 
> Regards,
>  Mika
> 

Gabriel
