Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZJ1KAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZJ1KAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZJ1KAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:00:10 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55703 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZJ1KAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=thCz3EuUxP/fQcKuchgdKS+RBRVmC6TPTfHBR0WeNJVj/5u4GRYO/hyAB+M6bjH2TS
         qwPMhfg2Xx4cz3oduN5AWwrUmsZKhrRwnr9dLxoJNp7hoBIt1/GQR02rd1NMzMhMQvrN
         OJlXTyoFic6VJwe3KkNdDe1obHWuo1ZPc/klU=
Message-ID: <4AE81625.5000500@panasas.com>
Date: Wed, 28 Oct 2009 12:00:05 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: "Leonidas ." <leonidas137@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       Noah Watkins <noah@noahdesu.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Difference between atomic operations and memory barriers
References: <f22d86810910261019yc77dbf0sa7688a98e7b98267@mail.gmail.com> <7ADB5FD7-9C97-4987-BC20-997258B25FD2@noahdesu.com> <f22d86810910261122j6c9e57e8pd4a257090f65c727@mail.gmail.com> <4AE5F04E.3050908@nortel.com>            <f22d86810910261200n130fda06r46fdbcc808195002@mail.gmail.com> <45208.1256644303@turing-police.cc.vt.edu>
In-Reply-To: <45208.1256644303@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2009 01:51 PM, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Oct 2009 00:30:45 +0530, "Leonidas ." said:
> 
>> So we can safely assume that pointer assignment will be done in an
>> atomic manner?
> 
> Has anybody ever actually made a *production* CPU that had non-atomic
> pointer assignments?  And how long before the crazed programmers lynched
> and burned the offending CPU designer at the stake? ;)
> 
> Non-atomic pointer assignments are the CPU design equivalent of Vogon poetry.
> Just Say No. With a shotgun if needed.

What don't you know? the CPU that started it all was like that, the x86 16-bit
"large" and "huge" model had a double register seg:offset set, also in-memory
was double-ints(2*16) even the i386 was running 16 bit modes for a long time.

Kernel still have 16-bit dosemu mode supported until today, no?

About the shotguns lynching and burning I'm not sure, but Intel survived
just fine.

Boaz
