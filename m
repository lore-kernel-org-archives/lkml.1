Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYF3HmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYF3HmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYF3HmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:42:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49038 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbYF3HmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:42:03 -0400
Message-ID: <48688DDE.9060802@jp.fujitsu.com>
Date: Mon, 30 Jun 2008 16:40:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>, rientjes@google.com
Subject: Re: [PATCH] doc: Document the relax_domain_level kernel boot argument
References: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com> <486883D0.8070409@jp.fujitsu.com> <486887EB.5090304@cn.fujitsu.com>
In-Reply-To: <486887EB.5090304@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Hidetoshi Seto wrote:
>> The system default is architecture dependent. You can change your
>> system's default using the relax_domain_level= boot parameter.
> 
> but the system default is 0 by default. and 0 means no search no matter
> what architecture is. ;)

If my git pull works correctly, it seems that the default is still -1...

[kernel/sched.c]
> static int default_relax_domain_level = -1;

AFAIK, for example, x86(SMT) search siblings by default.

Thanks,
H.Seto
