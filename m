Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbZCJLaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbZCJLaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZCJL37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:29:59 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:16309 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbZCJL36 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vPjQIrml0A0oFlCY/MYFuA3RpagODvPhyxk5clxGwwlpyPmmPn/d3W4BNMBJ71T3+p
         PPK3aLVTuK+uCNM1e31gfKqEQuzlR1js5Not9LLWlYMG0oIYBZDv4NMdYk4Jcs9r0VqA
         fU610Iz+9o79WtmdSwTOBZ3gjKBTViE6H3MiM=
MIME-Version: 1.0
In-Reply-To: <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
References: <1236670166-3910-1-git-send-email-graff.yang@gmail.com>
	 <8bd0f97a0903100103w6fc3dfc8se6076c98dbe5d8b4@mail.gmail.com>
	 <7d86d44a0903100425y2ed41d72p3ec43021f554af96@mail.gmail.com>
Date: Tue, 10 Mar 2009 07:29:56 -0400
Message-ID: <8bd0f97a0903100429t22515ebav286eb9447fc41a93@mail.gmail.com>
Subject: Re: [PATCH] [net/irda]: new Blackfin on-chip SIR IrDA driver
From: Mike Frysinger <vapier.adi@gmail.com>
To: graff yang <graff.yang@gmail.com>
Cc: samuel@sortiz.org, irda-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, graf.yang@analog.com, cooloney@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 07:25, graff yang wrote:
> On Tue, Mar 10, 2009 at 4:03 PM, Mike Frysinger wrote:
>> On Tue, Mar 10, 2009 at 03:29,  <graff.yang@gmail.com> wrote:
>> > +       baudrate_mask = IR_9600;
>> > +
>> > +       switch (max_rate) {
>> > +       case 115200:
>> > +               baudrate_mask |= IR_115200;
>> > +       case 57600:
>> > +               baudrate_mask |= IR_57600;
>> > +       case 38400:
>> > +               baudrate_mask |= IR_38400;
>> > +       case 19200:
>> > +               baudrate_mask |= IR_19200;
>> > +       }
>>
>> what if someone specified max_rate = 1231245 ?
>
> The  initial value of baudrate_mask is IR_9600.

i meant in terms of the user being notified it's a bogus value.  what
if they did max_rate=576000 ?  clearly they meant 57600, but they hit
"0" too many times ...
-mike
