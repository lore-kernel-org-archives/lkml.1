Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZJBWNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZJBWNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZJBWNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:13:08 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:51653 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbZJBWNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nNDpNXThDtDC/exL+/4lRdob7d5moQ1W69THgXm750K9kVouxHYUWlPvXPmrSBZVoO
         LzK9gRzJQGG2fX5zb9W0SgYN1RNV7vRWgIAwyXMXMnX+nZv1d4ePDlN5vIUOzECYdNVr
         uMn08KOFJesNRg+YPAJ5b5xOkSsSU5qInQUdk=
MIME-Version: 1.0
In-Reply-To: <200910022331.35916.rjw@sisk.pl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <COE24pZSBH.A.jd.5MTxKB@chimera>
	 <877hvd8rj5.fsf@spindle.srvr.nix> <200910022331.35916.rjw@sisk.pl>
Date: Fri, 2 Oct 2009 15:13:07 -0700
X-Google-Sender-Auth: cb397ba4b17bb86c
Message-ID: <9929d2390910021513t51827031k16a5bfc538640cbf@mail.gmail.com>
Subject: Re: [Bug #14261] e1000e jumbo frames no longer work: 'Unsupported MTU 
	setting'
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nix <nix@esperi.org.uk>,
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

On Fri, Oct 2, 2009 at 14:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday 02 October 2009, Nix wrote:
>> On 1 Oct 2009, Rafael J. Wysocki stated:
>>
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.30 and 2.6.31.  Please verify if it still should
>> > be listed and let me know (either way).
>>
>> The patch fixes it.
>>
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=14261
>> > Subject             : e1000e jumbo frames no longer work: 'Unsupported MTU setting'
>> > Submitter   : Nix <nix@esperi.org.uk>
>> > Date                : 2009-09-26 11:16 (6 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=125396433321342&w=4
>> > Handled-By  : Alexander Duyck <alexander.duyck@gmail.com>
>> > Patch               : http://patchwork.kernel.org/patch/50277/
>>
>> (Possibly a stable candidate? It's not in 2.6.31.2-to-be, perhaps the
>> only patch that isn't. ;) )
>
> Most likely because it's not in the Linus' tree yet.
>
> [e1000e maintainers, we have a regression fix to merge, please.]
>
> Thanks,
> Rafael

Sorry, I forgot to send this patch out last night.  I will send it now.

-- 
Cheers,
Jeff
