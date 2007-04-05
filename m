Return-Path: <linux-kernel-owner+w=401wt.eu-S1767272AbXDETwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767272AbXDETwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767273AbXDETwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:52:19 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:59736 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767272AbXDETwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k2+Kn2X5R6iv4Q1kxETIiEK2JsmwPiSrTsgsvXDbDcSBYjZY6ZBiiiB4akpY8aKW6UA5av7neEfa8dA01aPrJUdIyL/2RNs+Oq747X0NpEQ+iIPX0LLuAqAoSKs9UUDbWxfXhOaJVmpiWSad1JDEf8zaRKJl/CbOYGsZ4qMC4fU=
Message-ID: <a71293c20704051252o1a338353v22b68c5bb783963a@mail.gmail.com>
Date: Thu, 5 Apr 2007 15:52:17 -0400
From: "Stephen Evanchik" <evanchsa@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: AHCI exception, ext3 journal aborted on a VIA K8M890 / VT8251
In-Reply-To: <461139D5.1040705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a71293c20704011539ob1a86cbr7af70e37d678b1a6@mail.gmail.com>
	 <461139D5.1040705@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n 4/2/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> Stephen Evanchik wrote:
> > My hardware components are the following:
> >
> > Motherboard: A8V-VM Socket 939 VIA K8M890 / VT8251
> > CPU: Opteron 165 dual core
> > Harddisk: SATA 1.5Gbps WD 160GB drive
> >
> > Most relevant snippet from dmesg, (you can see a longer version below):
> >
> > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata1.00: cmd ca/00:08:c5:b6:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096
> > out
> >        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata1: soft resetting port
> > ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> > ata1.00: qc timeout (cmd 0xec)
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
> > ata1.00: revalidation failed (errno=-5)
> > ata1: failed to recover some devices, retrying in 5 secs
> > ata1: hard resetting port
> >

I have tested 2.6.20, 2.6.20.5, 2.6.21-rc5 and all exhibit the same behavior.

>
> We are testing fixes, but can only build test kernels for FC6. I think
> this may be fixed by patches I submitted for 2.6.20.5.
>

I still see the above problem from 2.6.19-rc1 to 2.6.21-rc5.


Stephen
