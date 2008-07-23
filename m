Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbYGWWlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbYGWWlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYGWWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:40:56 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:35030 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYGWWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:40:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding:sender;
        b=XbtCul+ORaVzso005jeFJs4RLrANOXnQ0yjJr9MGkm2raEZ2+DApt2BT3+o50Tqgku
         5xNW+vwbsHTrUtb3ktIN+Hchag+yAtBMhil2qzGNUnRGDWT2r1VRvh++KFRk5TkIhknj
         pTMrRBC07vhkPxvKrfPJwuKAb/ky4S0ZspqL4=
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, johnpol@2ka.mipt.ru, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       vegard.nossum@gmail.com, rjw@sisk.pl, cl@linux-foundation.org
In-Reply-To: <20080723.153143.10048360.davem@davemloft.net>
References: <20080721.163349.113841731.davem@davemloft.net>
	 <20080722075000.GB15807@elte.hu> <20080722133415.GA23046@elte.hu>
	 <20080723.153143.10048360.davem@davemloft.net>
Content-Type: text/plain
Organization: Intel Corporation
Date: Wed, 23 Jul 2008 15:40:56 -0700
Message-Id: <1216852856.4427.5.camel@jtkirshe-mobile.jf.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 15:31 -0700, David Miller wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 22 Jul 2008 15:34:15 +0200
> 
> > it's now past 50 successful iterations with e1000e+netconsole enabled 
> > again with the fix applied, and not a single crash, hang, memory 
> > corruption or other weirdness happened. Jeff, please apply the fix 
> > below.
> 
> I'll take care of integrating this, thanks Ingo.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Thanks Dave.  I have the patch in my queue of patches to push, just had
not pushed it to you and Jeff yet.

-- 
Cheers,
Jeff

