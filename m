Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYC0LkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYC0LkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYC0LkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:40:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60345 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755831AbYC0LkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:40:06 -0400
Date: Thu, 27 Mar 2008 06:40:01 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] x86_64 boot: Add free_early to early
 reservation machanism
Message-Id: <20080327064001.61d3f470.pj@sgi.com>
In-Reply-To: <1206601746.3067.21.camel@caritas-dev.intel.com>
References: <1206601746.3067.21.camel@caritas-dev.intel.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang wrote:
> +	for (j = i+1; j < MAX_EARLY_RES && early_res[j].end; j++) ;

Could we space this code out a little, as in:

	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
		;

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
