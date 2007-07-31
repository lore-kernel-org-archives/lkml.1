Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbXGaLtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbXGaLtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751318AbXGaLs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:48:57 -0400
Received: from qb-out-0506.google.com ([72.14.204.229]:12656 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXGaLs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Gx2iC38GojmpBT4ni3G4TuLvI/imUAdGF2RRp+rR51cYLMQU9XfdRiYWoZsnfaY8UgoxD9Go0sFgvywlYFVakkBDYzKRnWwPIe0kf+qKINokIHxg/bYee2054RatCIWwc9WTInhz4ODfTMlNDkQlPdomShI38thCAiS8lhm0ISk=
Date: Tue, 31 Jul 2007 19:50:16 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes (take 4)
Message-ID: <20070731115016.GA6326@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070730113847.GA28404@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070730113847.GA28404@kernel.sg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 07:38:47PM +0800, Eugene Teo wrote:
>This patch fixes these warnings:
>
>fs/partitions/check.c: In function 'add_partition':
>fs/partitions/check.c:391: warning: ignoring return value of 'kobject_add',
>	declared with attribute warn_unused_result
>fs/partitions/check.c:394: warning: ignoring return value of
>	'sysfs_create_link', declared with attribute warn_unused_result
>fs/partitions/check.c:401: warning: ignoring return value of
>	'sysfs_create_file', declared with attribute warn_unused_result
>
>Got it right this time. Thanks Cornelia for help.
>

<snip>

This was already done some months ago, see this:
http://marc.info/?l=linux-mm-commits&m=117624330000536&w=2

I don't know why this work is duplicated.

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

