Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYAHT1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYAHT1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYAHT04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:26:56 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56741 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbYAHT0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:26:55 -0500
Date: Tue, 8 Jan 2008 20:26:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: travis@sgi.com
Cc: mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] percpu: Per cpu code simplification V3
Message-ID: <20080108192657.GC26491@uranus.ravnborg.org>
References: <20080108021142.585467000@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108021142.585467000@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 06:11:42PM -0800, travis@sgi.com wrote:
> 
> This patchset simplifies the code that arches need to maintain to support
> per cpu functionality. Most of the code is moved into arch independent
> code. Only a minimal set of definitions is kept for each arch.
> 
> The patch also unifies the x86 arch so that there is only a single
> asm-x86/percpu.h
> 
> V1->V2:
> - Add support for specifying attributes for per cpu declarations (preserves
>   IA64 model(small) attribute).
>   - Drop first patch that removes the model(small) attribute for IA64
>   - Missing #endif in powerpc generic config /  Wrong Kconfig
>   - Follow Randy's suggestions on how to do the Kconfig settings
> 
> V2->V3:
>   - fix x86_64 non-SMP case
>   - change SHIFT_PTR to SHIFT_PERCPU_PTR
>   - fix various percpu_modcopy()'s to reference correct per_cpu_offset()
>   - s390 has a special way to determine the pointer to a per cpu area

In your changelog comments you have this:
V1->V2
 - ...

V2->V3
- ...

But that really belongs below the "end-of-changelog" comment as this info
is relevant only for this submission to lkml and not in whats get committed.

As your submission did not include an RFC I assume this is expected to be 
the final version.

	Sam
