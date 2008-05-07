Return-Path: <linux-kernel-owner+w=401wt.eu-S932187AbYEGTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbYEGTA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932716AbYEGS7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:59:45 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:50113 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbYEGS7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:59:43 -0400
Message-ID: <fa686aa40805071159ta7076c3va07e63ffd582ada4@mail.gmail.com>
Date: Wed, 7 May 2008 12:59:42 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: monstr@seznam.cz
Subject: Re: [microblaze-uclinux] [PATCH 04/56] microblaze_v2: Open firmware files
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       "John Linn" <linnj@xilinx.com>, john.williams@petalogix.com,
       matthew@wil.cx, will.newton@gmail.com, drepper@redhat.com,
       "Michal Simek" <monstr@monstr.eu>
In-Reply-To: <4821F794.10003@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
	 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
	 <20080507160432.93FC11750046@mail35-dub.bigfish.com>
	 <4821F794.10003@seznam.cz>
X-Google-Sender-Auth: 83457ef7d673c31f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 12:40 PM, Michal Simek <monstr@seznam.cz> wrote:
> Hi Steve,
>
>  you are right. Microblaze don't need CONFIG_PPC_something but
>  I keep this in files because it will be easier to move this to better place.
>  I wanted to sort what Microblaze don't use.
>
>  I need to talk with people from sparc and powerpc what we can move and where.
>  I see the best way to push these files to microblaze/kernel/ and then sychronize
>  them with one patch - all archs together.

I would disagree.  I think its better to push (and get merged) patches
to move the files first; then add microblaze on top of that.  You can
start getting stuff merged piecemeal that way instead of relying on
getting your entire patch series merged at once.

However, that's just my opinion, others may look at it differently.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
