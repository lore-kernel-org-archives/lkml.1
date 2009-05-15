Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZEOU32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZEOU32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZEOU3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:29:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39918 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZEOU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:29:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=sAHQCqDi5ob82m1awI8lMNWhpteOFSp01OcTGY87X1d+BK9I1iIfy5c2sHfxCNLLi
	HjGJqeVkd1TU3iJHqoacg==
MIME-Version: 1.0
In-Reply-To: <20090515195644.GA1377@ucw.cz>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa>
	 <20090515195644.GA1377@ucw.cz>
Date: Fri, 15 May 2009 13:29:15 -0700
Message-ID: <a84d7bc60905151329h677e5a96l76a9a7d708bfc5ad@mail.gmail.com>
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
From: Adam Langley <agl@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, markus@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 12:56 PM, Pavel Machek <pavel@ucw.cz> wrote:
> If you allow setuid exec here, you have added a security hole. Deny
> setuid() to sendmail and have fun...

Good point there. If you have any seccomp enabled you shouldn't be
able to run suid binaries. Being able to deny random syscalls to suid
binaries is too scary.

If this patch ever goes anywhere I'll add that.


Thanks

AGL
