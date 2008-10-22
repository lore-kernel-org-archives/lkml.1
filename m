Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYJVMO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYJVMO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYJVMOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:14:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:7547 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYJVMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:14:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PefFkeDH0rd+O853dmfCfSUYrFUwa6C5A2LWNZY6bYC7jNrt+6CT7CjjqEZDVfloxG
         TxWsCedB+qSENF8cGnsGGxYVTDVqOdYhEpHdWEISUHgktg3UQYhLWcGRLQANjIol/ofv
         ByQgGUMJO3T5toIunJC1pdtFMuaPT+hFCnUqM=
Message-ID: <58cb370e0810220514x419c9669jba1b7be942d3644a@mail.gmail.com>
Date: Wed, 22 Oct 2008 14:14:17 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [git pull] IDE updates #4
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48FF134F.2070509@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810212100.52985.bzolnier@gmail.com>
	 <48FF134F.2070509@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 1:49 PM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Bartlomiej Zolnierkiewicz wrote:
>
>> Remove needless/confusing subdirs from drivers/ide/.
>>
>
>  I think that with 2 new drivers being submitted/reworked based on feedback
> and several patches submitted and pending submission to the pata-2.6 series
> this really could have waited till 2.6.29...

The situation is perfect right now for this change as there are no outstanding
patches in pata-2.6 tree and number of new submitted patches is < 10 (I'll take
care of fixing them up, ditto for all other new stuff that will be using old
naming scheme).

Thanks,
Bart
