Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbYJ0OhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbYJ0OhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 10:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750727AbYJ0OhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 10:37:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49041 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750713AbYJ0OhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 10:37:00 -0400
Message-ID: <4905D24A.1040901@sgi.com>
Date: Mon, 27 Oct 2008 07:38:02 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator	driver
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com> <49024B1D.1050407@sgi.com> <20081027114205.GB5631@elte.hu>
In-Reply-To: <20081027114205.GB5631@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
...
> 
> Please send the cpu_idle() cleanup patch separately.
> 
> Another minor thing i noticed:
> 
> @@ -130,7 +140,9 @@ struct uv_hub_info_s {
>  	unsigned char	blade_processor_id;
>  	unsigned char	m_val;
>  	unsigned char	n_val;
> +	struct uv_scir_s scir;
> 
> please align the new field vertically, like they were aligned before - 
> by adding another tab to the whole lineup. (This will also make it 
> appear nicer when viewed together with followup definitions below this 
> section)

Ok, will do, thanks!

Mike
