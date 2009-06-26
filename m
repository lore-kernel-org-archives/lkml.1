Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZFZOsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZFZOsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZFZOr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:47:56 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62042 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbZFZOr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MEPx/ld+KIDuorzNm27OeiN9Po9Oh+aKdH+9bHTXB1Qbm9nmGOkboSfx3O6AVSNSze
         eM5cMf7XfyJVkKIrraFJkS3fk2ALNbIVXfDhjKt7Le5Zzyoo5FJs6QV4rBQBKhaFOp1R
         Z1aHHsbcXweDqMb4hXPrkkmG5A1y3J0lGtlto=
MIME-Version: 1.0
In-Reply-To: <b08bcbf50906260735q6af6522dl6f1bb407f68a801e@mail.gmail.com>
References: <b08bcbf50906260704s11181158r27d88e2dd518b1e9@mail.gmail.com>
	 <20090626150856.7b5fafb2@lxorguk.ukuu.org.uk>
	 <b08bcbf50906260735q6af6522dl6f1bb407f68a801e@mail.gmail.com>
Date: Fri, 26 Jun 2009 20:17:57 +0530
Message-ID: <1f808b4a0906260747i610b68bej2eaeb87d72e24c08@mail.gmail.com>
Subject: Re: Kernel hard_start_xmit performance vs SOCK_RAW performance
From: Peter Chacko <peterchacko35@gmail.com>
To: Gallus <gall.cwpl@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you try using PACKET socket interface  from your module  ?
(essentially as fast as hard-start-transmit() path ...there will be
tools that can be used for this purpose....I am not sure of any such
tool though...:-) you need to skip the scheduling (qdiscs) path also..

I think, Linux-net mailing list would be more appropriate to have this
discussion.

Thanks,
Peter

NetDiox computing systems
Bangalore-india
www.netdiox.com
080 2664 0708

On Fri, Jun 26, 2009 at 8:05 PM, Gallus<gall.cwpl@gmail.com> wrote:
> 2009/6/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> On Fri, 26 Jun 2009 16:04:04 +0200
>> Gallus <gall.cwpl@gmail.com> wrote:
>>
>>> Hi,
>>> what path would you choose to rapidly generate packets
>>
>> Documentation/networking/pktgen.txt
>
> Thank you Alan for the answer.
>
> However, my goal is to generate packets with certain *content* in them.
>
> --
> Regards,
> Gallus
> please CC me
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
