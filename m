Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXIMM3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXIMM3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbXIMM32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:29:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:45597 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbXIMM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=h/uTQ/rrplw7FF0hAQpA2ZYJpIOLV2dORq6XmojMoE52mZBYvnA8/Y2f97+R4ZrNrzvEtmnHJ6SbvS1YsReG4Dx9c2uBdZtOdSBINJ9HgcTKpRlXsx7Dfe3lgV8GB0Mem8Fp8rumwrgziPjYz0XOFOE0GIYldTS7DA7hDKSsra4=
Message-ID: <46E92D27.8050706@gmail.com>
Date: Thu, 13 Sep 2007 14:29:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc4-mm1: deadlock while mmaping video device
References: <46E9226F.9010700@gmail.com> <20070913044726.1aa48f45.akpm@linux-foundation.org>
In-Reply-To: <20070913044726.1aa48f45.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Thu, 13 Sep 2007 13:43:43 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Hi,
>>
>> I have this circular lock dependency on 2.6.23-rc4-mm1 when opening
>> /dev/video0 and mmaping it. the v4l driver is stk11xx:
>> http://www.fi.muni.cz/~xslaby/sklad/panics/mm-deadlock.png
>>
>> Using slub on x86_64 if that matters.
>>
>> For now, I'm unable to set up a netconsole, so only the picture linked above
>> is the best I have.
>>
> 
> oop, I think you'll want this:

yes, thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
