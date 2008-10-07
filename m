Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYJGViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYJGViT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbYJGViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:38:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:6403 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYJGViI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=JM7mxNBP4Wplr62ekcQ93v8U5Ir272A69d5rQT2jVxZoMGSzC52tVUAx+LFK82vrVO
         xcnma7Y1G1SA78l21/aPeCstrgk8zTU2wCtBnRCa+mXHFjnvUVBde9/M3oqisuU61BEX
         nqqbvoH6n23QIlOhUgeKtPulkvoVNkqIcZhgs=
Message-ID: <2f11576a0810071438x59e51b74rc8c1919c14739395@mail.gmail.com>
Date: Wed, 8 Oct 2008 06:38:07 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Ingo Molnar" <mingo@redhat.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081007211038.GQ20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name>
	 <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com>
	 <20081007211038.GQ20740@one.firstfloor.org>
X-Google-Sender-Auth: c664102e5a508f2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Sorry, no.
>> This description still doesn't explain why this interface is needed.
>>
>> The one of the points is this interface is used by another person or not.
>> You should explain how large this interface benefit has.
>>
>> Andi kleen explained this interface _can_  be used another one.
>> but nobody explain who use it actually.
>
> Anyone who doesn't want to use fixed addresses.

yup.
however, almost application doesn't use new flag because almost
application want to works on cross platform. (or merely lazy)
then, this explain isn't enough, imo.
