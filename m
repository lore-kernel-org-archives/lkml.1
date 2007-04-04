Return-Path: <linux-kernel-owner+w=401wt.eu-S966308AbXDDFlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966308AbXDDFlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966313AbXDDFlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:41:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:55911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966308AbXDDFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:41:51 -0400
Message-ID: <46133A5F.5000100@zytor.com>
Date: Tue, 03 Apr 2007 22:40:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: getting processor numbers
References: <461286D6.2040407@redhat.com> <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com> <4612ABD7.3000201@redhat.com> <4612F1F0.5070209@zytor.com> <4612F2BF.7080704@goop.org> <4612F394.6040105@zytor.com> <4613330C.1020701@cosmosbay.com> <461334B5.7070607@zytor.com> <46133609.9060402@goop.org>
In-Reply-To: <46133609.9060402@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> Mutable data should be separated from code.  I think any current CPU
>> will do fine as long as they are in separate 128-byte chunks, but they
>> need at least that much separation.
> P4 manual says that if one processor modifies data within 2k of another
> processor executing code, it will trash the entire trace cache.

Yuck.  Didn't realize the P4 was that sensitive.  OK, so at the least we 
need a half-page of separation.

	-hpa
