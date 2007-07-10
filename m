Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbXGJItu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbXGJItu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbXGJItn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:49:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:54236 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbXGJItm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=r8wKhbTIg86TdpyIGs0cHles6ak0hYQVEd4VQNpO23cboeNhxnpUTAodPiUsApDB4805o+po63QaDnRoIZlTBGZdq0Bdu1K0SKU+fOSqm5MsK1//wjA7WTPn4O+4V4Ecsiof+tjU2EQe/jeOABD8bULSPxfyDFmRa/F8QtukEpA=
Message-ID: <46934821.5020409@gmail.com>
Date: Tue, 10 Jul 2007 17:49:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs and suicidal attributes
References: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>	<46931495.4050605@gmail.com> <20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070710102857.15a57337@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
>> I like it because it shifts complexity from the drivers into driver
>> core.  IOW, the driver model is kinder to drivers that way - the driver
>> writer doesn't have to care whether something is suicidal or not - and I
>> think that's the way we should be headed although we're not good at it yet.
> 
> It might be that I misunderstand the idea, but doesn't the device
> driver writer need to consider whether the attribute is suicidal as
> well? (If it is the method that needs to call the sysfs core.)

What I was trying to say was that suicide and murder could be done the
same way from the driver's POV or am I misunderstanding?

> A general immediate disconnect of the buffers (which will be handled in
> a second pass) would be great, but doesn't sound easy.

I haven't thought too hard about actual implementation but it's pretty
specific case.  If doing things in generic manner is difficult, there
are plenty of shortcuts to choose from, I think.

-- 
tejun
