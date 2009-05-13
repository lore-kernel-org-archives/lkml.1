Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZEMFs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZEMFs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZEMFst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:48:49 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:63396 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZEMFst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:48:49 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fJzz1202hzz5a6ciz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJKIRS-01-7HR-01
Date: Wed, 13 May 2009 07:47:21 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       Robert Richter <robert.richter@amd.com>, Dave Jones <davej@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 10/10 -tip] x86: collect_cpu_info() of AMD user of
	Microcode feature
Message-ID: <20090513054721.GC9991@alberich.amd.com>
References: <1242142623.2547.13.camel@ht.satnam> <1242142692.2547.15.camel@ht.satnam> <1242142753.2547.16.camel@ht.satnam> <1242142807.2547.18.camel@ht.satnam> <1242142849.2547.19.camel@ht.satnam> <1242142908.2547.20.camel@ht.satnam> <1242142941.2547.21.camel@ht.satnam> <1242142996.2547.22.camel@ht.satnam> <1242143041.2547.23.camel@ht.satnam> <1242143078.2547.24.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1242143078.2547.24.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 May 2009 05:47:49.0422 (UTC) FILETIME=[595354E0:01C9D38E]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:14:38PM +0530, Jaswinder Singh Rajput wrote:
> 
> use X86_FEATURE_MICROCODE to determine microcode update
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

NAK.

>  arch/x86/kernel/microcode_amd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 453b579..1178638 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -90,7 +90,8 @@ static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
>  	u32 dummy;
>  
>  	memset(csig, 0, sizeof(*csig));
> -	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
> +	if (c->x86_vendor != X86_VENDOR_AMD ||
> +	    !cpu_has(c, X86_FEATURE_MICROCODE)) {
>  		printk(KERN_WARNING "microcode: CPU%d: AMD CPU family 0x%x not "
>  		       "supported\n", cpu, c->x86);
>  		return -1;
> -- 
> 1.6.0.6


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


