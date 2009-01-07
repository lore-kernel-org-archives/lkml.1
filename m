Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZAGNek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZAGNek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZAGNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:34:11 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:34162 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZAGNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:34:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dtaI/TF8n18RQjbqwqRW2ATB5+wQTscqNC8+rtVS+AMzMC7S6RvghPkzRnEunIy+oC
         9wCY+nAuuz2NgFIb1W0Odqi8Rq02Idkm0QAAz0AlFrXrx8z62WqSi/EtIGSUqXOzylDR
         16qT3RaxzMooGd4gV55/MbVkyX0TB7HcItXC8=
Message-ID: <3f9a31f40901070534t4442fb97vf8ed381c63b6354f@mail.gmail.com>
Date: Wed, 7 Jan 2009 19:04:06 +0530
From: "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: scripts/checkpatch.pl : undefined value as an ARRAY reference
Cc: "Andrew Morton" <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090107130415.GC3529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40901070454x678f75d2xee2a6de04a940321@mail.gmail.com>
	 <20090107130415.GC3529@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 6:34 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>
>> Hello Andy,
>>
>> On -tip git I am getting this error:
>>
>> $ ./scripts/checkpatch.pl 000*
>> Can't use an undefined value as an ARRAY reference at
>> ./scripts/checkpatch.pl line 451.
>>
>> But earlier it was working great. Is this a feature or a bug.
>
> bug.
>
> One for the akpm bucket i think, Andrew pushed v26 checkpatch to Linus
> yesterday:
>
> 57b9c6d: checkpatch: version: 0.26
> 21caa13: checkpatch: fix the perlcritic errors
> 2b6db5c: checkpatch: struct file_operations should normally be const
> b53c8e1: checkpatch: ensure we actually detect if assignments split across lines
> 2d1bafd: checkpatch: do not report nr_static as a static declaration
> 4635f4f: checkpatch: track #ifdef/#else/#endif when tracking blocks
> 8b1b337: checkpatch: fix continuation detection when handling spacing on operators
> 8054576: checkpatch: loosen spacing on typedef function checks
> 080ba92: checkpatch: try to catch missing VMLINUX_SYMBOL() in vmlinux.lds.h
> 86f9d05: checkpatch: allow parentheses on return for comparisons
> 1e85572: checkpatch: Add warning for p0-patches
> 2a5a2c2: checkpatch: update copyrights
> 50a7dcf: checkpatch: version: 0.25
> 6586386: checkpatch: dissallow spaces between stars in pointer types
> fae17da: checkpatch: comment ends inside strings is most likely not an open comment
> 8e761b0: checkpatch: detect multiple bitfield declarations
> 5fe3af1: checkpatch: __weak is an official attribute
> 383099f: checkpatch: structure member assignments are not complex
> 83242e0: checkpatch: widen implied comment detection to allow multiple stars
> 721c1cb: checkpatch: comment detection may miss an implied comment on the last hunk
> 691d77b6: checkpatch: add checks for in_atomic()
>
> one of those is causing this new warning.
>

it seems error to me :

./scripts/checkpatch.pl
0007-x86-smp.h-move-boot_cpu_id-declartion-to-cpu.h.patch
Can't use an undefined value as an ARRAY reference at
./scripts/checkpatch.pl line 453.

yesterday it was working great.

Thanks
--
JSR
