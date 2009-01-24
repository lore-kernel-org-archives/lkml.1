Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZAXAwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZAXAwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 19:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZAXAv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 19:51:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbZAXAv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 19:51:58 -0500
Message-ID: <497A6618.4080603@zytor.com>
Date: Fri, 23 Jan 2009 16:51:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 -tip 0/3] x86: reduce fixup of uaccess
References: <4962CAAE.6090300@ct.jp.nec.com> <496476D0.5040607@zytor.com> <497A5737.8030408@ct.jp.nec.com>
In-Reply-To: <497A5737.8030408@ct.jp.nec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> ChangeLog v1 -> v2
> 	- Change framework syntax. Previous version doesn't look easy to read.
> 	  Remove parens from try and add redundant braces as Peter suggested.
> 		get_user_try {
> 			get_user_ex(...);
> 			:
> 		} get_user_catch(err);
> 	- Remove double underscores.

Cool, looks a lot nicer this way.

I will try to try it out today.

	-hpa

