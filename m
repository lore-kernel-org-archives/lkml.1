Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYEEPKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYEEPKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbYEEPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:10:45 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:21444 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYEEPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:10:44 -0400
Message-ID: <fa686aa40805050810w2a0ff71fv9daff4ba198cf978@mail.gmail.com>
Date: Mon, 5 May 2008 09:10:43 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "John Williams" <john.williams@petalogix.com>
Subject: Re: [PATCH 45/56] microblaze_v2: headers simple files - empty or redirect to asm-generic
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <1209954849.5798.80.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
	 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
	 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
	 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
	 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
	 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
	 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
	 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
	 <1209954849.5798.80.camel@localhost>
X-Google-Sender-Auth: a3f35559f7545f43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 8:34 PM, John Williams
<john.williams@petalogix.com> wrote:
>
>  >  include/asm-microblaze/auxvec.h            |   14 ++++++++++++++
>  >  include/asm-microblaze/cputime.h           |   16 ++++++++++++++++
>  >  include/asm-microblaze/div64.h             |   16 ++++++++++++++++
>  >  include/asm-microblaze/emergency-restart.h |   16 ++++++++++++++++
>  >  include/asm-microblaze/errno.h             |   16 ++++++++++++++++
>  >  include/asm-microblaze/futex.h             |   16 ++++++++++++++++
>  >  include/asm-microblaze/kdebug.h            |   19 +++++++++++++++++++
>  >  include/asm-microblaze/local.h             |   16 ++++++++++++++++
>  >  include/asm-microblaze/mutex.h             |   16 ++++++++++++++++
>  >  include/asm-microblaze/namei.h             |   24 ++++++++++++++++++++++++
>  >  include/asm-microblaze/percpu.h            |   16 ++++++++++++++++
>  >  include/asm-microblaze/resource.h          |   16 ++++++++++++++++
>  >  include/asm-microblaze/user.h              |   18 ++++++++++++++++++
>
>  These are all just includes of asm-generic/* (hooray!).
>
>  But, is it reasonable to to suggest adding asm-generic at the end of the
>  kernel include path, and save all this verbosity?
>
>  Principle of least surprise maybe?

Convention in the other archs is already established to explicitly
include asm-generic files one by one.  It is probably best to match
existing convention for commonality sake.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
