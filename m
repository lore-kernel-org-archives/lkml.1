Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZHKVTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZHKVTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 17:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZHKVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 17:19:51 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:41474 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZHKVTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 17:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kn6buwGwnPyLkFRI07M1oPsSDtpfPeT+Htwe7QotbPb92NdfWmZhtC7MSfC/zXnyHC
         1GJNf4qHAwB/fugAG6qhWuPq23FHr8swS/ZRoEobW1OmrSYgQJ7l8BzbXZp5qIKQIIhg
         HC2uGHomQeSWiD1sbIpmd+I6yZGI7Q7RwNbs0=
Message-ID: <4A81E073.5080703@gmail.com>
Date: Tue, 11 Aug 2009 23:19:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-7.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/1] Power: fix suspend vt regression
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com> <20090811170050.GA26041@suse.de>
In-Reply-To: <20090811170050.GA26041@suse.de>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 07:00 PM, Greg KH wrote:
> On Tue, Aug 11, 2009 at 10:41:33AM +0200, Jiri Slaby wrote:
>> vt_waitactive no longer accepts console parameter as console-1
>> since commit "vt: add an event interface". It expects console
>> number directly (as viewed by userspace -- counting from 1).
> 
> As the event interface code is only in -next and not in mainline, this
> doesn't pertain to Linus's current tree, right?

Correct. But please ignore this one. The comment above is correct, but
the change should have been done one level deeper. A new patch for this
will follow.

However there is still a race or something. Sometimes the suspend goes
through, sometimes it doesn't. I will investigate this further.
