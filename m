Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZFKPYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZFKPYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZFKPYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:24:39 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:36902 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZFKPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eK/4xfX/ORBp5NadNHNHovI4S1d3k6MzRX7FrnuEoU6SAuGaVXrW8bZw6+7P3Xqn8+
         CMdWtNxI3DUWhLrEXHmgttWXhh1c+NiXvuvtAdbCngoT6Z1rYUmCAzBUe5f/IowQ0U1J
         vMjpOyeUEaT/sDiXGZbVOcsRKqMFxyYYGsmqM=
MIME-Version: 1.0
In-Reply-To: <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
	 <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
	 <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain>
	 <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906110954030.29827@gentwo.org>
	 <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com>
Date: Thu, 11 Jun 2009 18:24:40 +0300
X-Google-Sender-Auth: f756d21eea100ded
Message-ID: <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early boot SLAB for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mingo@elte.hu, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Jun 11, 2009 at 5:06 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
> I have not tested hotplug and cpuset_init_early() does indeed needs to
> be switched over to slab (it does that via fallback now).

Oh, my bad, Yinghai took care of cpusets too:

http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=d39aad49c3e672b7de393c39438529243610c1ad

The patch shouldn't have probably labeled as "x86" but anyway, it's
taken care of. CPU hotplug initialization isn't using the bootmem
allocator so I don't see a problem with that either. Or did you have
something specific in mind?

                                              Pekka
