Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZCUWq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZCUWq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZCUWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:46:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:31900 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbZCUWqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=cbk6xtAW6Oj1vZkeXOLt4L+Im8zE+WmpGtm8F4Of6VB+SpDqozmD+mQq3HGiEkWQrl
         +lDxuDs1gCKK279tWURTpvwn01fhgr1MZ5jUKfswuxGufOfYLxASNdaKUJPcJH0oSMLR
         49wjL2kXnkUO6kn0q443UINK1CTHE7tWgfDCM=
MIME-Version: 1.0
In-Reply-To: <49C5699C.8050405@emcraft.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <49C41C1E.4060401@zytor.com> <49C4201A.5060905@emcraft.com>
	 <49C425F5.8060309@intel.com> <49C42F99.5010700@emcraft.com>
	 <49C45159.8020503@zytor.com>
	 <e9c3a7c20903210819r222cd4acwb466d2a11d3388f6@mail.gmail.com>
	 <49C53CC0.5060303@zytor.com>
	 <e9c3a7c20903211514p60fda2fbhc5039c16f708e81d@mail.gmail.com>
	 <49C5699C.8050405@emcraft.com>
Date: Sat, 21 Mar 2009 15:46:12 -0700
X-Google-Sender-Auth: 8e31a0f9dc95ff10
Message-ID: <e9c3a7c20903211546k75b5ac48uab083303b6ec5746@mail.gmail.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF 
	multiplication
From: Dan Williams <dan.j.williams@intel.com>
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "H. Peter Anvin" <h.peter.anvin@intel.com>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "neilb@suse.de" <neilb@suse.de>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Yuri Tikhonov <yur@emcraft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 3:26 PM, Ilya Yanok <yanok@emcraft.com> wrote:
>> The caller needs to be modified to only require scalar multiplication
>> even in this corner case.
>>
>
> Argh... There is no vector-vector multiplication at all! You just need
> to swap the 'for' cycles back (as it was in the original patch by me and
> Yuri) to get rid of two-dimensional lookup at each step.

Yes, I swapped the loops as part of the removal of the
ASYNC_TX_ZERO_{P,Q} flags and wanted to avoid an explicit memset.
I'll rework this path...

Regards,
Dan
