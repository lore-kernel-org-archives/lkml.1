Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZCDMNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZCDMNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbZCDMNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:13:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:35937 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757058AbZCDMNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:13:34 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18n+oY0hjcnPoKQpZ9Hl54qmktUeSPnoH7AyoPVa0
	WWYrCQnU26NXL7
Subject: Re: x86-tip: cpufreq breakage -
	bisection	fingers	89c9215165ca609096e845926d9a18f1306176a4
From: Mike Galbraith <efault@gmx.de>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49AE4C26.4040104@kernel.org>
References: <1236085632.5958.8.camel@marge.simson.net>
	 <20090303143106.GA12248@elte.hu> <1236098338.5926.0.camel@marge.simson.net>
	 <49ADE077.1060606@kernel.org> <1236138205.6119.12.camel@marge.simson.net>
	 <1236147277.6049.3.camel@marge.simson.net> <49AE2028.8040402@kernel.org>
	 <49AE4C26.4040104@kernel.org>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 13:13:29 +0100
Message-Id: <1236168809.14171.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 18:38 +0900, Tejun Heo wrote:

> I wonder what is going on.  I'll try again with
> 89c9215165ca609096e845926d9a18f1306176a4.  Argh... weird.

marge:/ # modprobe processor
FATAL: Error inserting processor (/lib/modules/2.6.29-tip-smp/kernel/drivers/acpi/processor.ko): Invalid module format

I've got 80 _other_ modules loaded/working just fine, only the cpufreq
stuff won't play ball.

I re-installed binutils/gcc/modutils, checked my repo via git fsck and
rebuilt from scratch, and the problem remains.  That very same module
loads and cpufreq works just peachy with the hacklet I posted.

Yup, pretty weird.

	-Mike

