Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbYCGVBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbYCGVBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 16:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYCGVBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 16:01:23 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:8571 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755654AbYCGVBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 16:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v6Y1tWGDTjq5I08H0iTNFvyrtMK7T6m3BbZ7vXEI+Lm6C9rYOwd7SpGjr4c1Xmp18LQPsiPa8MkCvWu0oTGFSrDzmPSRQhpThyvnWYaQGRDBKtKJRfiNjwYhvjLPr9f/Fo9k++hqzkoqhI+YOmpYp+LPOcQqwXeFEk4HkzbfUlk=
Message-ID: <7c86c4470803071301n553273a8t231534ffce51b8b5@mail.gmail.com>
Date: Fri, 7 Mar 2008 13:01:18 -0800
From: "stephane eranian" <eranian@googlemail.com>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [PATCH 2/3] perfmon x86 infrastructure definitions
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
In-Reply-To: <20080307114249.GA12930@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470803062225y4727a19ic321314b292dd874@mail.gmail.com>
	 <20080307114249.GA12930@erda.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Fri, Mar 7, 2008 at 3:42 AM, Robert Richter <robert.richter@amd.com> wrote:
>
> On 06.03.08 22:25:26, stephane eranian wrote:
>  > adds AMD Northbridge config MSR definition
>  >
>  > Signed-off-by: Stephane Eranian <eranian@gmail.com>
>  > Signed-off-by: Robert Richter <robert.richter@amd.com>
>
>  > --- a/include/asm-x86/msr-index.h
>  > +++ b/include/asm-x86/msr-index.h
>  > @@ -83,6 +83,7 @@
>  >  /* AMD64 MSRs. Not complete. See the architecture manual for a more
>  >     complete list. */
>  >
>  > +#define MSR_AMD64_NB_CFG             0xc001001f
>
>  This will probably not be needed after mm config works fine (patches
>  from Yinghai Lu). Since the usage of CF8 extended configuration cycles
>  is not recommended, the current code to enable IBS interrupts can be
>  seen as temporary. I will rework the IBS code so that it uses mm
>  config.
>
Ok, but I want to push what we have now. We can change this later.
