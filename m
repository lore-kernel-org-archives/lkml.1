Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZBWCci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZBWCci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZBWCc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:32:29 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50072 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZBWCc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:32:29 -0500
Message-ID: <49A20ACE.7020309@cn.fujitsu.com>
Date: Mon, 23 Feb 2009 10:32:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: Re: Question for remount
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>    <6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com> <d7928a87d8c1bf661e3a3b64db9fa988.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <d7928a87d8c1bf661e3a3b64db9fa988.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Paul Menage さんは書きました：
>> On Fri, Feb 20, 2009 at 2:02 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> 2. /proc/mounts information of release_agent should be updated....
>>>   when it's overwritten directly.
>> Yes, definitely. But shouldn't that happen already?
>> cgroup_show_options() reports the current value of
>> root->release_agent_path in /proc/mounts. Is it possible that mount is
>> actually storing/retrieving this information in /etc/mtab, which
>> doesn't get updated?
>>
> Ah, you're right. /proc/mounts is updated but /etc/mtab is not updated.
> Hmm..from man mount(1), /etc/mtab is not synchronized with /proc/mounts.
> Do we need to allow release_agent override at remount ?
> 

Since we've allowed this behavior, I think we shouldn't disallow it to
supprise users?

