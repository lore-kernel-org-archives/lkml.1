Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYJWLia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYJWLia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYJWLiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:38:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:62362 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbYJWLiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=dXJ7gjRxF7ySBhPzdcx3d8VbHUFQfLz4zXy1KviPN98Uozk6MUWIJabu5jpEaOJgZ4
         KpLHEFFFIkvb2EMromqKNR/EOd7k7sCb658YfB12faep88eTWWn01qp/UTZ5QT6mKSst
         yaNU6r8VqeDbNmzsyN4ykRviSWXgsV0b01/Ks=
Date: Thu, 23 Oct 2008 15:41:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How do I printk <type> correctly?
Message-ID: <20081023114133.GA30187@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If variable is of Type	use	printk format specifier.
---------------------------------------------------------
		int			%d or %x
		unsigned int		%u or %x
		long			%ld ot %lx
		unsigned long		%lu or %lx
		long long		%lld or %llx
		unsigned long long	%llu or %llx
		size_t			%zu or %zx
		ssize_t			%zd or %zx

Raw pointer value SHOULD be printed with %p.

u64 SHOULD be printed with %llu/%llx, (unsigned long long):

	printk("%llu", (unsigned long long)u64_var);

s64 SHOULD be printed with %lld/%llx, (long long):

	printk("%lld", (long long)s64_var);

If type is dependent on config option (sector_t), use format specifier
of biggest type and explicitly cast to it.

Reminder: sizeof() result is of type size_t.

Thank you for your cooperation.
