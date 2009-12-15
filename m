Return-Path: <linux-kernel-owner+w=401wt.eu-S1751150AbZLOPKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150AbZLOPKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbZLOPKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZLOPKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:10:47 -0500
Message-ID: <4B27A6BC.5080402@redhat.com>
Date: Tue, 15 Dec 2009 10:09:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com
Subject: Re: [RFC, PATCH 0/4] elf_core_dump(): Add extended numbering support
References: <20091215.114053.193686180.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20091215.114053.193686180.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi HATAYAMA-san,

Daisuke HATAYAMA wrote:
> Question to Maintainers
> ========
> 
> I know these patches are conflicting with Hiramatsu-san's
> (http://lkml.org/lkml/2009/11/28/143), so I am planning to remake
> them. But now, I don't know what tree is sutable to send these
> patches. Do you have any suggestions?

Currently, my patches are merged into Andrew's -mm tree.
I think your patch also may be picked up to -mm tree.

BTW, I had asked him and Ingo that is possible to copy it to
-tip tree too, because coredump tracepoint patch depends
on both of signal-tracepoint and the coredump parameters
patch. However, since now signal-tracepoint patches has
been merged to linus git tree, I assume that coredump
tracepoint patch can be applied after -mm tree moved on
to .33-rc1.


Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

