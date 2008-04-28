Return-Path: <linux-kernel-owner+w=401wt.eu-S935898AbYD1Tr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935898AbYD1Tr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935564AbYD1Tqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:46:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937102AbYD1Tqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:46:50 -0400
Message-ID: <4816299B.5040002@zytor.com>
Date: Mon, 28 Apr 2008 12:46:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Markus Metzger <markus.t.metzger@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: DS cleanup - dont treat 0 as NULL
References: <20080428191504.GA6842@cvg>
In-Reply-To: <20080428191504.GA6842@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Actually I wonder why in original code Atom processors was
> _that_ aligned? Was it made with a special purpose? yes,
> it's a mobile platform, but can't see any reason for such
> alignment.
> 

[...]

> @@ -825,7 +825,7 @@ void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
>  			ds_configure(&ds_cfg_var);
>  			break;
>  		case 0xF: /* Core2 */
> -        case 0x1C: /* Atom */
> +		case 0x1C: /* Atom */
>  			ds_configure(&ds_cfg_64);
>  			break;
>  		default:
> 

Nevermind, I was looking for a *memory* alignment... :-/

	-hpa
