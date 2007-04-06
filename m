Return-Path: <linux-kernel-owner+w=401wt.eu-S1750909AbXDFTHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750909AbXDFTHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXDFTHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:07:10 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbXDFTHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:07:08 -0400
Message-ID: <46169A34.3030808@zytor.com>
Date: Fri, 06 Apr 2007 12:06:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>	<20070406094413.GA673@tv-sign.ru>	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>	<20070406154750.GA541@tv-sign.ru>	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Oleg is coming from a different case where it was found that exiting kernel
> threads were causing problems for nash when nash was run as init in an
> initramfs.  While I think that case is likely a user space bug because
> nash should check the pid from waidpid before assuming the process it
> was waiting for returned.
> 

Are you saying waitpid() (wait4) *with a pid specified* can return 
another pid?  That definitely sounds like a bug.

	-hpa
