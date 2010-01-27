Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485Ab0A0XSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab0A0XSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087Ab0A0XSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:18:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915Ab0A0XSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:18:34 -0500
Message-ID: <4B60C9A6.10704@redhat.com>
Date: Wed, 27 Jan 2010 18:17:58 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
References: <1264633557-17597-1-git-send-email-acme@infradead.org> <1264633557-17597-4-git-send-email-acme@infradead.org>
In-Reply-To: <1264633557-17597-4-git-send-email-acme@infradead.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Removing one extra step needed in the tools that need this, fixing a bug
> in 'perf probe' where this was not being done.

Thanks,
BTW, when O_WRONLY should be used? I guess I might misunderstand something
in builtin-probe.c, and it should use O_RDONLY ...



-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

