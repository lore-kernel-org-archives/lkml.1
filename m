Return-Path: <linux-kernel-owner+w=401wt.eu-S1751688AbXA0AmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbXA0AmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXA0AmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:42:02 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:8028 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXA0AmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:42:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=lW8+7d9N/z0ZVJVWDIz+VjYJyvg4iwpY0IWytQP6Kdh/hHUYND4eP2Krew+WS646eoANfgoRgf01/fhXSTTjtjVCAzfaKb8pw11ACOorEswvLyot9/EEBQkzYp5lbEgZaQw+RX9zg0+OxspLhGH+TkxW6iQfK8gdTb+48i351vY=
Message-ID: <45BA9FCD.8050200@googlemail.com>
Date: Sat, 27 Jan 2007 01:41:49 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Vance <cvance@nai.com>, Wayne Salamon <wsalamon@nai.com>,
       James Morris <jmorris@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>	<45BA5A65.8040500@googlemail.com>	<6bffcb0e0701261523j3a84a357lad93260b5865c99d@mail.gmail.com> <20070126163328.939922a3.akpm@osdl.org>
In-Reply-To: <20070126163328.939922a3.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Sat, 27 Jan 2007 00:23:47 +0100
> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> On 26/01/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>> akpm@osdl.org napisał(a):
>>>> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
>>>>
>>>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
>>> security/selinux/hooks.c: In function 'selinux_sysctl':
>>> security/selinux/hooks.c:1440: error: 'ctl_table' has no member named 'de'
>>> make[2]: *** [security/selinux/hooks.o] Error 1
>>> make[1]: *** [security/selinux] Error 2
>>> make: *** [security] Error 2
>>>
>>> Sysctl patches?
>> Thanks Eric, it builds fine.
>>
> 
> It doesn't for me.  What did you change?  Did you receive some unseen-by-me patch
> from Eric?
> 

Subject: sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables-hack
From: Andrew Morton <akpm@osdl.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>

Upss. It's your patch, thanks.

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
