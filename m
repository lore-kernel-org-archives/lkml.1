Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbXCRJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbXCRJi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXCRJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 05:38:29 -0400
Received: from smtp.osdl.org ([65.172.181.24]:32818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbXCRJi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 05:38:29 -0400
Date: Sun, 18 Mar 2007 01:38:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH]RTC: add rtc-rs5c313 driver
Message-Id: <20070318013804.1e7beced.akpm@linux-foundation.org>
In-Reply-To: <20070309120302.e257ee6c.iwamatsu@nigauri.org>
References: <20070309120302.e257ee6c.iwamatsu@nigauri.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007 12:03:02 +0900 Nobuhiro Iwamatsu <iwamatsu@nigauri.org> wrote:

> Hi , all .
> 
> Add an RTC driver for Ricoh RS5C313 RTC chip.
> 


drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_read_reg':
drivers/rtc/rtc-rs5c313.c:186: warning: implicit declaration of function 'rs5c313_write_data'
drivers/rtc/rtc-rs5c313.c:187: warning: implicit declaration of function 'rs5c313_read_data'
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_read_time':
drivers/rtc/rtc-rs5c313.c:208: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:208: error: (Each undeclared identifier is reported only once
drivers/rtc/rtc-rs5c313.c:208: error: for each function it appears in.)
drivers/rtc/rtc-rs5c313.c:217: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_set_time':
drivers/rtc/rtc-rs5c313.c:265: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:273: error: 'RS5C313_MISCOP' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:274: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_check_xstp_bit':
drivers/rtc/rtc-rs5c313.c:315: error: 'RS5C313_CEENABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:324: error: 'RS5C313_MISCOP' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c:336: error: 'RS5C313_CEDISABLE' undeclared (first use in this function)
drivers/rtc/rtc-rs5c313.c: In function 'rs5c313_rtc_init':
drivers/rtc/rtc-rs5c313.c:390: warning: implicit declaration of function 'rs5c313_init_port'

I think we're missing a header file?
