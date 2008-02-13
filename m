Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbYBMW2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbYBMW2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYBMW1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:27:52 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:33344 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYBMW1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:27:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gdsCEpxZcMwivfAAtlfyZTe7vJf2gfnm7Q0svANfjRQF7JMVZBAaMLtPvrTkzzb7llMI6i6ukI+qkQqgtF7LdZrq7pJGFUbmcKAaRfGhR8Nxszw06alXbQGljGQvXWYeSneQ1gN17KE8HXnURWbu1mkSc58iGn/xaEMb08ggzRM=
Subject: Re: [2.6 patch] x86: make dump_pagetable() static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Adrian Bunk <bunk@kernel.org>, Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080213213131.GA3383@cs181133002.pp.htv.fi>
References: <20080213213131.GA3383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 14:27:47 -0800
Message-Id: <1202941667.18204.14.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 23:31 +0200, Adrian Bunk wrote:
> dump_pagetable() can now become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

I believe Andi Kleen wanted this kept global to make it easy to use when
adding debugging code elsewhere.

Cheers,

Harvey

