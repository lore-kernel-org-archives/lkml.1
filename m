Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbZKHRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbZKHRYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZKHRYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:24:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:50887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZKHRYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:24:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,704,1249282800"; 
   d="scan'208";a="744963877"
Subject: Re: [PATCH] trivial: fix checking socket() in net tstamp example
From: Patrick Ohly <patrick.ohly@intel.com>
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091108155923.GA820@lilem.mirepesht>
References: <20091108155923.GA820@lilem.mirepesht>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Nov 2009 18:24:05 +0100
Message-ID: <1257701045.29123.288.camel@pohly-mobl1.ikn.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-08 at 15:59 +0000, Ali Gholami Rudi wrote:
> Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
> ---
>  .../networking/timestamping/timestamping.c         |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/networking/timestamping/timestamping.c b/Documentation/networking/timestamping/timestamping.c
> index a7936fe..bab619a 100644
> --- a/Documentation/networking/timestamping/timestamping.c
> +++ b/Documentation/networking/timestamping/timestamping.c
> @@ -370,7 +370,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
> -	if (socket < 0)
> +	if (sock < 0)

Argh, of course you are right. FWIW, acknowledged.

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.


