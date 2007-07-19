Return-Path: <linux-kernel-owner+w=401wt.eu-S1765391AbXGSMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765391AbXGSMl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbXGSMlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:41:19 -0400
Received: from mx1.suse.de ([195.135.220.2]:49837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbXGSMlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:41:18 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: new text patching for review
Date: Thu, 19 Jul 2007 14:41:15 +0200
User-Agent: KMail/1.9.6
Cc: prasanna@in.ibm.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, patches@x86-64.org
References: <469F6669020000780003960B@public.id2-vpn.continvity.gns.novell.com>
In-Reply-To: <469F6669020000780003960B@public.id2-vpn.continvity.gns.novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191441.15194.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 14:25:59 Jan Beulich wrote:
> I like this approach much better, just one small note (I think I
> had the same mistake in my changes initially):
> 
> >@@ -202,7 +209,7 @@ static void alternatives_smp_lock(u8 **s
> > 			continue;
> > 		if (*ptr > text_end)
> > 			continue;
> >-		**ptr = 0xf0; /* lock prefix */
> >+		text_poke(ptr, 0xf0); /* lock prefix */
> > 	};
> > }
>  
> You probably want *ptr here.

Thanks fixed

-Andi
