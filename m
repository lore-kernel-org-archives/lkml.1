Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZL2W2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZL2W2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZL2W2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:28:15 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:35235 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZL2W2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:28:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=YP8JmPolixHlDsL6q6vnLwR0dbVEkymWR1IAlMv0ds6wwGn7Az4voTd3/7HQA1mDkF
         a7cMCXVC+J7jsIYaStZpljT1LztAVr9i3Zf/EpKqtvm+OY1oMFc8mL7ikB8mYfM9ZV6Q
         wVr9EOtzUItDfJ4HICdIEA/oiiozotQJl56h4=
References: <200912271003.631128760@firstfloor.org> <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box> <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box> <1262016510.12656.25.camel@wall-e> <20091228172651.GE4994@basil.fritz.box> <1262030653.15368.37.camel@wall-e>  <20091228204003.GH4994@basil.fritz.box> <1262076056.23095.21.camel@wall-e>
Message-Id: <64D5262E-28CF-41E8-9425-F8C5DD0A2265@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
In-Reply-To: <1262076056.23095.21.camel@wall-e>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
Date: Tue, 29 Dec 2009 14:27:52 -0800
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2009, at 12:40 AM, Stefani Seibold <stefani@seibold.net>  
wrote:

> Am Montag, den 28.12.2009, 21:40 +0100 schrieb Andi Kleen:
>
>
>> OK i checked and they all use power-of-two currently so by sheer
>> luck (I doubt it is by design) they work. Still I think that
>> open deathtrap should be fixed.
>>
>
> It is fixed, and i hope it will be included in 2.6.34.
>
>> I also don't understand how that patch "breaks your future work"
>> Please elaborate on that.
>>
>
> Very difficult to explain in a email, but i will try it:
>
> The new macro based kfifo API handles everything as elements of a  
> given
> type. So you can have the old "unsigned char"-fifo, but also fifo of
> every other type like int's, struct's and so on. The kfifo_in() and
> kfifo_out() len parameter is than in the meaning of elements not  
> bytes.
> So you are able to process more than one value at a time and the  
> macros
> will return the number of processed elements (not bytes).

Does anyone want this kind of functionality though? Why can't we keep  
the old interface as is (and maybe deprecate it) and use the new  
record API you mentioned below for record-oriented kfifos.

Thanks.

-- 
Dmitry

