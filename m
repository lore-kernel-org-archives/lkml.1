Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbZC2Qod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbZC2Qod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758913AbZC2QkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:40:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:64156 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbZC2QkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:40:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=PH2QRuokAnxmJsBFY+KXkJLbDNvXe7oZk+IuR7qtpXvqfQTLcrp/ZiR9L4GdbMhsGG
         u2KgYEZQiWEhW7CVLaGV+gVwkpFsiOWYExiG+X/jp9zZwZeVgWIbDEz+o/q6niNAd10z
         W+Qqc8+Fkk3+5dPVFiWXjCfegXKKUFEyBGQEs=
Date: Mon, 30 Mar 2009 00:41:02 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] kernel/module.c: fix an unused goto label
Message-ID: <20090329164102.GG7671@hack>
References: <20090324160719.GE9686@hack> <20090324192647.GA26930@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324192647.GA26930@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 08:26:47PM +0100, Ingo Molnar wrote:
>
>* Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> Label 'free_init' is only used when defined(CONFIG_MODULE_UNLOAD) &&
>> defined(CONFIG_SMP), so move it inside to shut up gcc.
>> 
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>
>was already sent a week ago - see below.
>

Oh, OK then! Thanks for your point! Please ignore my patch. :)


-- 
Do what you love, f**k the rest! F**k the regulations!
 
