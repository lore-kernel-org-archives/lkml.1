Return-Path: <linux-kernel-owner+w=401wt.eu-S934701AbYBNV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934701AbYBNV2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYBNV2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:28:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:19771 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYBNV2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:28:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TNtciLZHGRWu1W6BZTS8BQ5B1urv5WbzEmIGaWxMQE893Ik0lQ3hZWosWiqMAmcVU1r4it+qrtllVdcRgVh7l/jHKJoJjkcYa0fjwPujgQiPEPpVAVYrT3T7oEV2IjNdtNlbj1PJDNJnwLcEbfuI1CWo25PsFdK1DOEMKVd/KVo=
Message-ID: <12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com>
Date: Thu, 14 Feb 2008 13:27:58 -0800
From: "Tony Luck" <tony.luck@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <adaprv0rygh.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080213125725.GC6344@elte.hu>
	 <20080213.050340.64342037.davem@davemloft.net>
	 <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	 <20080213.170452.68851396.davem@davemloft.net>
	 <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
	 <adaprv0rygh.fsf@cisco.com>
X-Google-Sender-Auth: 993f924b553edda5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 7:47 PM, Roland Dreier <rdreier@cisco.com> wrote:
>  The strange thing is that Ingo's patch to make cpu_clock() a NOP until
>  after sched_init() didn't fix things for me...

Very strange.  I threw in an output line counter into the printk code() ... if I
disable the timestamps for the first 30 lines, then everything is good (so the
basic timestamping code does still work on ia64). But I would have thought
that Ingo's delay until sched_init() ought to be long enough too. Clearly I
need to figure out exactly what needs to be initialized to prevent the
hang/crash.

-Tony
