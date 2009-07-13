Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZGMVtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZGMVtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZGMVtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:49:19 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:45188 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZGMVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=L5rlmnr0KxCaC+26sHfcCofiT2kwKbyuo/58O2BWkIVbuA9bDpfSQnHpDWcunb4v7a
         kEN3BBgsFi7r3dG0iprXf52iNyjZOpGGPpnl5W4Cs34uTv45lQWxRfkXfqhdIMzS5u8b
         Sco2g0wBEQhMjg8whPiFgCjDe0kp5EAecDj+k=
Message-ID: <4A5BABDB.2070600@gmail.com>
Date: Mon, 13 Jul 2009 23:49:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com>
In-Reply-To: <4A5BAABF.9020708@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 11:44 PM, Jiri Slaby wrote:
>> I've had local hacks
>> many times to make sparse aware of mutexes, is there a reason they are
>> not annotated with __acquire(s)/__release(s) like spinlocks etc.?
> 
> Mutexes are often locked/unlocked interprocedural which I think sparse
> can't do much about.

(which means it has high false positive rate in those cases)
