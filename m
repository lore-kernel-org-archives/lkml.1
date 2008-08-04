Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYHDKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYHDKh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 06:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYHDKhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 06:37:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:32538 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbYHDKhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,304,1215414000"; 
   d="scan'208";a="603872854"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217844725.3454.580.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 06:35:39 -0400
Message-Id: <1217846139.20845.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 11:12 +0100, David Woodhouse wrote:
> You could perhaps just use 'unsigned long' here, to avoid the ifdef.
Thanks. 
> And it would be nice if we could make libcrc32c use this too, rather
> than just the 'crypto' users.
>From previous discussing, herbert would like to transfer the libcrc32c 
interface by new crypto because there were few user using the current 
libcrc32c interface. 

