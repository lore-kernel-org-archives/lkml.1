Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbZALBCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbZALBCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 20:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZALBCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 20:02:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZALBCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 20:02:03 -0500
Message-ID: <496A965F.6050209@zytor.com>
Date: Sun, 11 Jan 2009 17:01:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Dieter Ries <clip2@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <20090111190218.GA18651@elte.hu> <496A451C.5030400@sgi.com>
In-Reply-To: <496A451C.5030400@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> 
> About the return 0, it was the default return for another error case.
> Should the function panic because it can't read a cpu reg?  That seems
> wrong too.
> 

The only other error case I see is when the value simply is zero by
definition.  This is a memory allocation failure, which is quite a bit
different -- the former is that the query *can't* be answered, the
latter that the query *won't* be answered...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

