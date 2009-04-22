Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZDVOrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZDVOrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZDVOq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:46:59 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:54771 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZDVOq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:46:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=i3SSKghZEVw+QL+45s9BBOR7kW+lO5W4j4haO3zP2Vg672ORwon72zh/zHUQOIOXSy
         BCmndnApHSmryng1m3lCe8kGcONQdU78mnRadhnq/l0pZDhvOc/NNOTCwJ8/b/SDHM6E
         IWYEqsc/e8ad1Jfn7zG6caXRzKvw+2TLv7j6o=
MIME-Version: 1.0
In-Reply-To: <f44001920904220732h2d6d18cfwef53af31bb218b87@mail.gmail.com>
References: <f44001920904220712ye1644c9y90d637bf4ac3bbe@mail.gmail.com>
	 <871vrkpyae.fsf@basil.nowhere.org>
	 <f44001920904220732h2d6d18cfwef53af31bb218b87@mail.gmail.com>
Date: Wed, 22 Apr 2009 18:46:56 +0400
Message-ID: <f44001920904220746k356550abk6783b8cae003685d@mail.gmail.com>
Subject: Re: Re: Idea: Feature information / extensions dispatcher syscall.
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/22 Andi Kleen <andi@firstfloor.org>:
> Igor Zhbanov <izh1979@gmail.com> writes:
>>
>> This allow to use system calls in any extension modules without need to reserve
>> syscall number in kernel source and allow binaries to run correctly on
>> any kernel
>> (where that extension feature can have another syscall number).
>>
>> What do you think?
>
> You're trying to reinvent the vfs / device nodes / ioctls

Perhaps.
But in some cases syscalls are more convenient than reading/writing/ioctling
in /proc, /sys or /dev.

Now as I understand creating new syscalls for "home" use is not encourahed.
It is not guaranteed that tomorrow new syscall will not be introduced
in mainstream kernel. So portability issues is not considered for
"home" modules.

And I suggest to regulate syscalls usage and reserve a set of numbers
"home" modules used in some organizations only.

I don't think that they all will use only devices and /proc and /sys
to communicate
with their modules.
