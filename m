Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZLORPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZLORPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932604AbZLORPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:15:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbZLORPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:15:37 -0500
Message-ID: <4B27C437.5010607@redhat.com>
Date: Tue, 15 Dec 2009 12:15:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] perf symbols: Make symbol_conf global
References: <1260892717-20841-1-git-send-email-acme@infradead.org> <20091215161120.GH21796@ghostprotocols.net>
In-Reply-To: <20091215161120.GH21796@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Tue, Dec 15, 2009 at 01:58:35PM -0200, Arnaldo Carvalho de Melo escreveu:
>> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>>
>> This simplifies a lot of functions, less stuff to be done by tool
>> writers.
> 
> Ingo, this clashes with the batch Masami-san just submitted, please
> defer applying my series so that I can rework it to take into account
> the changes that Masami-san contributed.

Ah, thank you for working on that!
Feel free to update builtin-probe.c too :-) it might be use
symbol.c in different way from others. (for getting vmlinux path)

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

