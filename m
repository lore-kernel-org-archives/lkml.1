Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYKYMlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYKYMlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 07:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYKYMlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:41:13 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:43184 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYKYMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=uj+mSIzId8LYmuuCE0A45HQcIDWfwI3vKoX3PW+uXdvUn8MJQ4WJcm5u+qDRtcRoxh
         +uKmxpWfEyAg0H4W7yauPkfjYduGJcTVVl5FoxJSzZ4hq8sPEbPkFagr/CstFr4gp3Bb
         rjrA2tuLsF/If1C7t0qdxN5C5v29e5QSoAEfM=
Message-ID: <7c86c4470811250441p5f513756t2672d7dcc8037b77@mail.gmail.com>
Date: Tue, 25 Nov 2008 13:41:10 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: [patch 7/9] x86, pebs: export ds.c symbols
Cc: "Ingo Molnar" <mingo@elte.hu>, "Christoph Hellwig" <hch@infradead.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F3C31E@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081125090847.A31384@sedona.ch.intel.com>
	 <20081125082603.GB28031@infradead.org>
	 <20081125091229.GA22027@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3C31E@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

On Tue, Nov 25, 2008 at 11:24 AM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Dienstag, 25. November 2008 10:12
>>To: Christoph Hellwig
>>Cc: Metzger, Markus T; hpa@zytor.com;
>
>>* Christoph Hellwig <hch@infradead.org> wrote:
>>
>>> On Tue, Nov 25, 2008 at 09:08:47AM +0100, Markus Metzger wrote:
>>> > Export symbols in ds.c.
>>> >
>>> > The changes are required to allow perfmon2 to access DS.
>>>
>>> So put them into the perform2 patchset.
>>
>>yes - and they need to be EXPORT_SYMBOL_GPL() as well.
>
> OK.
>
> I will send a patch to Stephane, then, so he can include it into the perfmon2 series.
>
I will add your patch to my tree.
Thanks.
