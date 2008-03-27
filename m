Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbYC0LeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbYC0LeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 07:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYC0LeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 07:34:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37817 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755275AbYC0LeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 07:34:14 -0400
Date: Thu, 27 Mar 2008 06:34:11 -0500
From: Paul Jackson <pj@sgi.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] x86_64 boot: Add free_early to early
 reservation machanism
Message-Id: <20080327063411.8611cd8f.pj@sgi.com>
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
> +		panic("free_early on not reserved area: %lx-%lx!", start, end);

Should that be 'early_panic', not 'panic' ?

(I see a couple more panics in that file, which I wonder
if should be early_panic as well ?)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
