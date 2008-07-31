Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYGaA2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYGaA2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760295AbYGaA0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:26:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:5539 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762996AbYGaA0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:26:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=mY0ICS8MGCPm8XqRxN/vBSIU2AnvNsCa5pSoxhzQC5zVmjwSG38XhdcGG/LciHHj8j
         aUiJaPxxhwyZYz8Uq7/gHQJIyoZGmkbQa19B4foUjqgTQf14BwIcnarjyEMFeiy1zMhX
         Zypbc0s20/6w1LcuBQJuSLhGx4pmaruwM5YS0=
Message-ID: <7c86c4470807301726m7b828621le272400bca6bdf6a@mail.gmail.com>
Date: Wed, 30 Jul 2008 17:26:10 -0700
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [patch 00/19] perfmon2 minimal v3: introduction
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080731102154.b06476dd.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
	 <20080729014730.76b879a4.sfr@canb.auug.org.au>
	 <7c86c4470807282320o2d072c7dp7a327f133d5969c5@mail.gmail.com>
	 <7c86c4470807301659t232a8dabw5272988d164898e@mail.gmail.com>
	 <20080731102154.b06476dd.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen

On Wed, Jul 30, 2008 at 5:21 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Stephane,
>
> On Wed, 30 Jul 2008 16:59:34 -0700 "stephane eranian" <eranian@googlemail.com> wrote:
>>
>> On Mon, Jul 28, 2008 at 11:20 PM, stephane eranian
>> <eranian@googlemail.com> wrote:
>> >>        quite a few of the macros (especially for the dummy (non
>> >> CONFIG_PERFMON) versions of functions) should be "static inline"
>> >> functions unless they absolutely must be macros.  Andrew Morton said it
>> >> best - "write in C not C preprocessor".
>> >>
>> Do you also have a problem with the debug printk statements using macros?
>
> Not really, they would be a pain to write as C code.
>
That's what I am thinking as well!

> The advantage of using C code for the dummy versions of things is that we
> still get type checking and we eliminate "unused variable" warnings for
> parameters of the functions.
>
Will do the dummy functions as inline then.
