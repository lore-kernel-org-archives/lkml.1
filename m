Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZEEQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZEEQ37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZEEQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:29:50 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:39189 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbZEEQ3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:29:49 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2009 12:29:49 EDT
Date: Tue, 5 May 2009 17:13:22 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: coly.li@suse.de, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/7] mips cavium-octeon: add parameter to
	octeon_cvmcount_read()
Message-ID: <20090505161321.GA17945@linux-mips.org>
References: <49EF6A9E.6080605@suse.de> <49EF7F34.9040401@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EF7F34.9040401@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 01:33:56PM -0700, David Daney wrote:

> Coly Li wrote:
>> This patch modifies parameter of octeon_cvmcount_read() from 'void' to 'struct
>> clocksource *cs', which fixes compile warning for incompatible parameter type.
>>
>> Signed-off-by: Coly Li <coly.li@suse.de>
>> Cc: David Daney <ddaney@caviumnetworks.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>
> It looks good to me:
>
> Reviewed-by: David Daney <ddaney@caviumnetworks.com>

Applied, thanks.

Coly, if you modify MIPS code, please cc the linux-mips mailing list and
myself or generally consult the MAINTAINERS file for who to cc on patches.

Thanks!

  Ralf
