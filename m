Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZKHLCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZKHLCq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 06:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZKHLCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 06:02:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59022 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZKHLCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 06:02:44 -0500
Date: Sun, 8 Nov 2009 12:02:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andr? Goddard Rosa <andre.goddard@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/7] vsprintf: factorize "(null)" string
Message-ID: <20091108110237.GG11372@elte.hu>
References: <b8bf37780911040648h7e4bae3dg21ce15c6b0e680d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8bf37780911040648h7e4bae3dg21ce15c6b0e680d3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andr? Goddard Rosa <andre.goddard@gmail.com> wrote:

> @@ -546,12 +548,12 @@ static char *number(char *buf, char *end,
> unsigned long long num,
>  	return buf;
>  }
> 
> -static char *string(char *buf, char *end, char *s, struct printf_spec spec)
> +static char *string(char *buf, char *end, const char *s, struct
> printf_spec spec)

FYI, your patches have such linewraps, so the patches wont apply:

 patch: **** malformed patch at line 47: unsigned long long num,

See Documentation/email-clients.txt about how to send patches without 
such problems.

Mind resending with this fixed?

Also, this RFC patch of yours:

  vsprintf: reuse almost identical simple_strtoulX() functions

looks nice too IMO - mind including it in your series?

Thanks,

	Ingo

