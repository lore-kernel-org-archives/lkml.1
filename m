Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYFLW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYFLW6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYFLW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:58:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:44278 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753107AbYFLW6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:58:10 -0400
Message-ID: <4851AA00.1050006@sgi.com>
Date: Thu, 12 Jun 2008 15:58:08 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial console
References: <20080612223802.528617000@polaris-admin.engr.sgi.com>	<20080612223802.673729000@polaris-admin.engr.sgi.com> <20080612154600.fac8cc6b.akpm@linux-foundation.org>
In-Reply-To: <20080612154600.fac8cc6b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 12 Jun 2008 15:38:03 -0700
> Mike Travis <travis@sgi.com> wrote:
> 
>>  * Add config option EARLY_SERIAL_CONSOLE to enable early
>>    printk's to be directed to the serial console.
...
>>
> 
> Confused.  What's wrong with console=uart,...?
> 

The problem is that I need the output really, really early before
the console is initialized.
