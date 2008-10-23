Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYJWLvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYJWLvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYJWLvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:51:09 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:55840 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYJWLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cu9OW+qY0AvUdgrZVixVNzEcoYFP71HMy1SEDbuw3MMgXA37O9JvI0Rbzp7IrEpYJt
         OB3IjNGMwnvlhnIpOzXfwUWPeo8cZYdqaGY7SFbel95gSHrPdqrBCEq80ba/kpsgTvm7
         Daw1gL/gJ5XPLQ+G2KBToFHSgJbZMVlZwTgsw=
Message-ID: <49006553.4020401@gmail.com>
Date: Thu, 23 Oct 2008 17:21:47 +0530
From: David John <davidjonx@gmail.com>
Reply-To: davidjonx@gmail.com
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: How do I printk <type> correctly?
References: <20081023114133.GA30187@x200.localdomain>
In-Reply-To: <20081023114133.GA30187@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> If variable is of Type	use	printk format specifier.
> ---------------------------------------------------------
> 		int			%d or %x
> 		unsigned int		%u or %x
> 		long			%ld ot %lx
> 		unsigned long		%lu or %lx
> 		long long		%lld or %llx
> 		unsigned long long	%llu or %llx
> 		size_t			%zu or %zx
> 		ssize_t			%zd or %zx
> 
> Raw pointer value SHOULD be printed with %p.
> 
> u64 SHOULD be printed with %llu/%llx, (unsigned long long):
> 
> 	printk("%llu", (unsigned long long)u64_var);
> 
> s64 SHOULD be printed with %lld/%llx, (long long):
> 
> 	printk("%lld", (long long)s64_var);
> 
> If type is dependent on config option (sector_t), use format specifier
> of biggest type and explicitly cast to it.
> 
> Reminder: sizeof() result is of type size_t.
> 
> Thank you for your cooperation.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Useful list, but I think there are more format specifiers available with
printk though.

David.
