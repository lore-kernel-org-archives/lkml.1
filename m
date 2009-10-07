Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZJGJeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZJGJeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZJGJeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:34:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:38448 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZJGJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:34:04 -0400
Subject: Re: [PATCH] perf_event: Remove include/linux/perf_counter.h
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACC5F6D.7020809@cn.fujitsu.com>
References: <4ACC5F6D.7020809@cn.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 11:36:52 +0200
Message-Id: <1254908212.26976.229.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 17:29 +0800, Xiao Guangrong wrote:
> Remove include/linux/perf_counter.h because it's not used anymore after
> one of Ingo's patch:

The intent was to keep it around for one more release so as to not
inconvenience userspace that relied on it too much, ie. give them time
to convert.
