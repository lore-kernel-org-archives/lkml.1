Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbYAQXIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbYAQXIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYAQXIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:08:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYAQXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:08:03 -0500
Message-ID: <478FDE76.3070309@zytor.com>
Date: Thu, 17 Jan 2008 18:02:14 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
References: <1200611078.5724.46.camel@brick>
In-Reply-To: <1200611078.5724.46.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Use v8086_mode inline in fault_32.c, no functional change
> also ifdef the section for 32-bit only and add to fault_64.c

The #ifdef is unnecessary, since v8086_mode() is now a constant zero on 
x86-64.  gcc will remove the if clause.

	-hpa
