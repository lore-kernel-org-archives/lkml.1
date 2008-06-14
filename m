Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbYFNReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbYFNReV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 13:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYFNReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 13:34:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:7034 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYFNReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 13:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O9YoFuX6n+SjNRToEpjvuljvueRKqwQxwoL7k2zgbVoAQ1YtIEfpBWmJ1vFvzPfPbr
         OpBAsySSp6VZL32uo9TUyxZPxM8Qt6TheJURrON45j8JRRWoHQXpZ6hJafvhZ8kxnMH4
         uisGX1ND6yBJQeaLAWYr3CkJE4BcJApoblk7o=
Message-ID: <e1aa27e00806141034k6bab05f9g5ac01ed478a1e78f@mail.gmail.com>
Date: Sat, 14 Jun 2008 19:34:07 +0200
From: "Marco Barbero" <marco.barbero@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: OOM killer invoked on 2.6.24.4
In-Reply-To: <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com>
	 <e2e108260806140831s40f36a95s1a412cec4dc47f31@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/14 Bart Van Assche <bart.vanassche@gmail.com>:
> On Sat, Jun 14, 2008 at 12:13 PM, Marco Barbero <marco.barbero@gmail.com> wrote:
>> samba/slapd/heartbeat/drbd/mon
> ...
>> Jun 14 01:00:17 pippo kernel: Out of memory: kill process 6873 (slapd)
>> score 5003 or a child
>> Jun 14 01:00:17 pippo kernel: Killed process 6873 (slapd)
>>
>> Anyone can help me in understanding what went wrong? And if I need to
>> upgrade to last kernel version?
>
> One or more processes on your system used too much memory. Dumping the
> output of the following command periodically (e.g. every 10 minutes)
> to a file will tell you which process is using too much memory:

> { ps aux | head -n 1; ps aux | sort -n +4 | tail -n 10; }


I'll do it.  Have to say that this box had an uptime of 1 month and
never show issues. Also oom was invoked in the night when load is
minimum.
Could be related to slab and the quicklist leak?
