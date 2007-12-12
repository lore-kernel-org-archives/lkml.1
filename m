Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbXLLKVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbXLLKVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbXLLKVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:21:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:57470 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758129AbXLLKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tKbszuJfpsNy26Smde7XzoPT9geAYpQuOhUUvFes07FY8Al5dsWAtRzg2uTqDJcZR01RWofg1BY7/6MI0H60rlVIY5eNr6W1UvjBuS5CCaZo76RhRKEt7FFrFadxdGSSQ2EqP7KK2PJZlyNo9FvslaEEzBSsrQQP4xcODXcArBc=
Message-ID: <b6fcc0a0712120221h51a27cc5s1e17d3607412eadc@mail.gmail.com>
Date: Wed, 12 Dec 2007 13:21:44 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071212091144.GA11986@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071212091144.GA11986@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> 2.6.24-rc4-git5, got this cpufreq crash on x86 64-bit, during 'make
> randconfig' random bootup testing:

Ingo, since you already scripted this, maybe you can add
"modprobe everything/rmmod everything" test after successful bootup.
It will catch amazing amount of stuff, I promise.

Ditto for modprobe/rmmod/modprobe and modprobe/rmmod/cat /proc,
cat /sys smoke tests.
