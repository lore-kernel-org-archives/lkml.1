Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZGBC1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZGBC1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZGBC1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:27:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbZGBC1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:27:08 -0400
Message-ID: <4A4C1B33.2030002@cn.fujitsu.com>
Date: Thu, 02 Jul 2009 10:28:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
References: <4A4C0C60.4050106@cn.fujitsu.com>	 <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com>	 <4A4C18D5.7020806@cn.fujitsu.com> <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
In-Reply-To: <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>> But I guess we are going to fix the bug for 2.6.31? So is it ok to
>> merge a new feature 'cgroup.procs' together into 2.6.31?
>>
> 
> Does this bug really need to be fixed for 2.6.31? I didn't think that
> the namespace support in mainline was robust enough yet for people to
> use them for virtual servers in production environments.
> 

If so, it's ok for me. Unless someone else has objections. Serge?

