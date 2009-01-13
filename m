Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494AbZAMWka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494AbZAMWka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 17:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZAMWkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 17:40:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:35775 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZAMWkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 17:40:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Adytivqo+G/iDDUGs/FhTfJbWoxd+t42vuvWV0sjX8vXbCoRCAli3/aMpQU114PbeD
         mpBiDde1edNILBS9gRYjgWoQS8znDLzlLE5mKziSwxkWE2VIxJstGRqyxcbI4jxr7cBn
         eNQqTVCPbDirgdkxrBcA5GNnIMFYRDPPZERdg=
MIME-Version: 1.0
In-Reply-To: <20090113221235.GD19262@axis.com>
References: <20090113151406.GC19262@axis.com>
	 <20090113.131030.207355839.davem@davemloft.net>
	 <20090113221235.GD19262@axis.com>
Date: Wed, 14 Jan 2009 07:40:19 +0900
X-Google-Sender-Auth: 627cca46cacae45a
Message-ID: <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com>
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: David Miller <davem@davemloft.net>, "tj@kernel.org" <tj@kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "hinko.kocevar@cetrtapot.si" <hinko.kocevar@cetrtapot.si>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It may be that we've worked around the other spots, although I haven't
> seen anything like that, we might just have been lucky until now.
>
> Can you recall another place where this trick is used?

rmap.
Don't CRIS use mmu?

>
> It seems that rt_mutex uses the same trick (with the lowest 2bits)
> but AFAICT that's something we don't use on CRIS.
