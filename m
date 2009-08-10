Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZHJXNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZHJXNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZHJXM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:12:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:2587 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZHJXM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=luOHiw3TyRUmJV8DhTPu0y4Wt8krTc5pgPVqoPc3TSXf6rYP9jAajYjpzzhaq1VTvp
         FI4v3HT1R96Zt3zhAAK6HJFjs8SH2+tosHNzk3YBRmKqwQvDLqAIG96pX6NfXcEsyNTC
         k5v47Exdoz9ZcTgup+aIL/rQj3+EM3Gfh4fFQ=
Message-ID: <4A80A978.8090801@gmail.com>
Date: Tue, 11 Aug 2009 01:12:56 +0200
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: xterm loses data (pty regression)
References: <4A803CE7.20201@gmail.com> <2c0942db0908101007t54c39b64k2800b2c320969318@mail.gmail.com> <alpine.LFD.2.01.0908101016100.3288@localhost.localdomain> <alpine.LFD.2.01.0908101105040.3602@localhost.localdomain> <4A80702D.20701@gmail.com>
In-Reply-To: <4A80702D.20701@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artur Skawina wrote:
>Linus Torvalds wrote:
>> 
>>  static int pty_write_room(struct tty_struct *tty)
>>  {
>> +	if (tty->stopped)
>> +		return 0;
>>  	return pty_space(tty->link);
>>  }
> 
> w/ this, the pty writes now block again after ^Q, and the data loss is gone.

What i meant was "...pty writes now block again after ^S...", sorry.

artur
