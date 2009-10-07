Return-Path: <linux-kernel-owner+w=401wt.eu-S1759811AbZJGTNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759811AbZJGTNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZJGTNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:13:23 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:40345 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZJGTNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=taWkysiY/PWvHkzsQDxPWqCb1hv2eEM9HY897sE2EoYS8JHYojJwd5r92XREF068QN
         voJ/tAyO6hwAwp1puv/tT8RSXaIhSX2uzO03fADCe798LlKD2CJ6y/lnbK/aXOdrRD8m
         yiLfcGVv4216y/5w3vYRBzWQM9O5uv/mRUmOc=
MIME-Version: 1.0
In-Reply-To: <20091007183453.GD12971@mit.edu>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.jd.5MTxKB@chimera>
	 <877hvd8rj5.fsf@spindle.srvr.nix> <200910022331.35916.rjw@sisk.pl>
	 <9929d2390910021513t51827031k16a5bfc538640cbf@mail.gmail.com>
	 <20091007183453.GD12971@mit.edu>
Date: Wed, 7 Oct 2009 12:12:45 -0700
X-Google-Sender-Auth: acb3370336dab00c
Message-ID: <9929d2390910071212o632196b8o92899565bb131cea@mail.gmail.com>
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported MTU 
	setting'
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Theodore Tso <tytso@mit.edu>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Nix <nix@esperi.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Duyck <alexander.duyck@gmail.com>,
       Network Development <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 11:34, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Oct 02, 2009 at 03:13:07PM -0700, Jeff Kirsher wrote:
>> >> > Patch               : http://patchwork.kernel.org/patch/50277/
>> >>
>> > Most likely because it's not in the Linus' tree yet.
>> >
>> > [e1000e maintainers, we have a regression fix to merge, please.]
>>
>> Sorry, I forgot to send this patch out last night.  I will send it now.
>
> Do we have a status on this progress of this patch to mainline?   Thanks,
>
>                                        - Ted

The patch has been submitted and accepted into David Miller's net-2.6
tree.  I will submit the patch for 2.6.31 stable tree once it makes it
into Linus's tree later this week.

-- 
Cheers,
Jeff
