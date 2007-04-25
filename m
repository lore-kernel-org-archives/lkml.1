Return-Path: <linux-kernel-owner+w=401wt.eu-S1423126AbXDYGdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423126AbXDYGdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXDYGdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:33:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:55298 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423126AbXDYGdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AkMP8TQPMOYBpTsiIyTRsj4bfLjMXFICXMVrsjUcRRXmH90RFWkYYNVSJOjxNymU38T/yIkdY/D6I3SiSPs9/G5kPhrVfrZulo17ijvdxBkGyYbuQNCqMXDz1iCwURuGgCF1qphx332bBXGNsMlF/JvLjqBzeIqAx53CzDlx6yI=
Message-ID: <4ac8254d0704242333g17972a7q2106015af946ea5@mail.gmail.com>
Date: Wed, 25 Apr 2007 08:33:10 +0200
From: "Tuncer Ayaz" <tuncer.ayaz@gmail.com>
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Subject: Re: NonExecutable Bit in 32Bit
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net>
	 <Pine.LNX.4.64.0704240640470.25153@server.thyself>
	 <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com>
	 <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Cestonaro, Thilo (external)
<Thilo.Cestonaro.external@fujitsu-siemens.com> wrote:
> Hey,
>
> > CONFIG_HIGHMEM64G=y
> > CONFIG_HIGHMEM=y
> > CONFIG_X86_PAE=y
>
> Ok in highmem it's active, whats about lowmem?
> x86-64 is NX active for lowmem too AFAIK.

It's more of an issue of having PAE enabled.
Without PAE you are not able to use the the NX bit.
That's the way the CPU works, not Linux.

Hope this helps.
