Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbYKSStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbYKSStS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYKSStB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:49:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:40058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYKSStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:49:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=c0dPlYY+uCosfpVaCzEyrvhxRsTgI6AlGhBdTgUOoeS79+hlBoOREbRaj5riiMf7NU
         JzxXIH3gmCv3UOVFsl8YqzmrQZYvGfp8fO5A/HsDBsuWQxEP2dS8XXjqwYosF24+8jys
         ODoEBs/pvCd+xhaHlp6WHmpUALwq0INabLGf0=
Date: Wed, 19 Nov 2008 18:48:44 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] MODULE_UNLOAD should depend on PROC_FS
Message-ID: <20081119184844.GE22898@hack.voiplan.pt>
References: <20081118184052.GA24453@hack.voiplan.pt> <200811191041.53716.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200811191041.53716.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 10:41:53AM +1030, Rusty Russell wrote:
>On Wednesday 19 November 2008 05:10:52 Américo Wang wrote:
>> The feature controlled by MODULE_UNLOAD uses proc interface, so it
>> should depend on PROC_FS.
>
>Hi Wang,
>
>   This patch looks wrong to me; you can remove modules without /proc.  Does 
>it not compile with CONFIG_MODULE_UNLOAD=y and CONFIG_PROC_FS=n?
>

Thank you, Rusty and Alan!

I think I was wrong. It is compiled fine with the above config, just tested.


-- 
"Sometimes the only way to stay sane is to go a little crazy."

