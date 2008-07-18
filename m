Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbYGRBnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbYGRBnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYGRBnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:43:06 -0400
Received: from main.gmane.org ([80.91.229.2]:44322 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbYGRBnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:43:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: Does 2.6.26 provide nanosecond time to the user?
Date: Fri, 18 Jul 2008 02:42:53 +0100
Message-ID: <yw1x1w1srmqq.fsf@thrashbarg.mansr.com>
References: <200807180019.m6I0J2kG026240@deneb.dwf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:6WPGp94xRIhTQlkU4YejoIpDDo0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reg Clemens <reg@dwf.com> writes:

> Im confused.
> (sorry I havent been following the linux-kernel mailing list on this)
>
> Does 2.6.26 use nanosecond time
>     (1) internally?
>     (2) provide it to the user?
>
> I see no way to turn it on/off in xconfig.
> Yet I do see STA_NANO defined in sys/timex.h which is a good start.
>
> and IF it provides it to the user, what do I use to get nanosecond time.
> My search with man -k for timespec turns up
>       sys_clock_getres
> and sys_clock_gettime
>
> or possibly clock_getres and clock_gettime, the man pages use both,
> but NONE of these entry points seem to exist in my system.

You might need to link with -lrt to get those functions.

-- 
Måns Rullgård
mans@mansr.com

