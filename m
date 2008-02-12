Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYBLGLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYBLGLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761098AbYBLGK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:10:59 -0500
Received: from cerberus.nrc.co.nz ([60.234.156.227]:55535 "EHLO
	cerberus.nrc.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761038AbYBLGK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:10:56 -0500
Message-ID: <47B1385B.1020908@nrc.co.nz>
Date: Tue, 12 Feb 2008 19:10:35 +1300
From: "Nick 'Zaf' Clifford" <zaf@nrc.co.nz>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: serge@hallyn.com
CC: linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>,
       linux-security-module@vger.kernel.org
Subject: Re: if (2.6.24.1 && capset && bind9) bug() --RESOVLED
References: <47B03592.20505@nrc.co.nz> <20080212033815.GA28437@vino.hallyn.com>
In-Reply-To: <20080212033815.GA28437@vino.hallyn.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serge@hallyn.com wrote:
> Quoting Nick 'Zaf' Clifford (zaf@nrc.co.nz):
>   
>> Please CC me on any/all replies
>>
>> After trying to upgrade to deal with the most recent security issue, I
>>     
>
> Judging by the 2.6.24.2 changelog I don't think the 2.6.24.1 kernel you
> grabbed has the fix you're looking for...
>   
Yes, that I realize now (I'll refer back to the lack of sleep thing
caused by a long, long, long day), and speaking of which....... see below
>> have encountered what has to either be me being very tired, or a kernel
>> bug. After assuming that it was the former for 3 hours, I now conclude
>> I'm more tired, and it has to be the latter.
>>
>>     
> Yeah my first thought was enough has been happening on the capabilities
> front that it could be an unfortunate patch merge, but 2.6.24.1 looks
> ok.  So my next guess would be an selinux change.  Though again i don't
> see anything obvious.  Could you tell us what policy you use, and what
> context bind is starting in?
>   
>

2.6.24.2 seems to fix the issue, so thanks to whoever noticed and fixed
that (and if no one fixed anything, then I'm just a raving loon, and you
can move on with your day, content that the nice man raving about
fictitious bugs is happy again).

But FYI and for what its worth, although SELinux was compiled, it isn't
being used. Its disabled on boot.

Thanks for the reply and help anyways,

Nick


