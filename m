Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXKASos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXKASos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXKASob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:44:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759325AbXKASo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:44:29 -0400
Message-ID: <472A1EA1.3070109@redhat.com>
Date: Thu, 01 Nov 2007 16:44:49 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [PATCH] x86: show cpuinfo only for online CPUs
References: <20071101170206.GA7820@alberich.amd.com> <472A08F9.8060605@redhat.com> <20071101173543.GB5568@alberich.amd.com> <20071101183537.GD5568@alberich.amd.com>
In-Reply-To: <20071101183537.GD5568@alberich.amd.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andreas Herrmann3 escreveu:
> On Thu, Nov 01, 2007 at 06:35:43PM +0100, Andreas Herrmann3 wrote:
>> On Thu, Nov 01, 2007 at 03:12:25PM -0200, Glauber de Oliveira Costa wrote:
>>> So it could even work, but as accident. Unless I'm wrong about it, I'd
>>> prefer to see an explicit attribution of cpu_index = 0 somewhere for the
>>> boot cpu.
>> Hmm, will look at this as well.
> 
> BTW, isn't it zero initialized anyway?
> So, no need to explicitely set cpuinfo->cpu_index=0 for the boot cpu.

Well, it should be, but as far as I know it is not exactly a guarantee
given by all compilers. So it should be safer to do it explicitly, with
no prejudice. Unless it's really guaranteed. If it is, yeah, no need.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHKh6hjYI8LaFUWXMRAmVXAJ47DCzJjWIQQ/duiVXtevsw1Y5gaQCfSOoU
uXq3vfX/NQjWk1lGQJCW6+E=
=qhGb
-----END PGP SIGNATURE-----
