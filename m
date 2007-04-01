Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXDAQqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXDAQqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXDAQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:46:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:1883 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXDAQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:46:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NgAr114fMCcqBdR6R9c8vPtgX1S57oEv/7hhycoq7vPMait4/GJ/Ou+mfvNiJtWztYi5JGILVHpOaSj4SJYd+OZjjVM64vG/koedmH0y9YfkBDD/Ca8BsPQ0QavHRaWWtCR1ZZ6fFTLV/hnVoPoEbBmVXssApyT2KYxHwPtTkGE=
Message-ID: <c43b2e150704010946h5442897cyb8a125decd90b2aa@mail.gmail.com>
Date: Sun, 1 Apr 2007 18:46:02 +0200
From: wixor <wixorpeek@gmail.com>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: System hang on athlon64 cpufreq change
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1449F58C868D8D4E9C72945771150BDFD96725@SAUSEXMB1.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c43b2e150703161151i3bf45074v54208542ca2212d3@mail.gmail.com>
	 <1449F58C868D8D4E9C72945771150BDFD96725@SAUSEXMB1.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Langsdorf, Mark <mark.langsdorf@amd.com> wrote:
> The processor is not changing frequency in response to your
> launch of mplayer.  The powersave governor forces it to the
> lowest frequency regardless of system load.  You really want
> to use ondemand for dynamic frequency scaling.
>
> Can you use a serial or network console to capture any messages
> the kernel is sending when mplayer starts?
>
Well, that's the point - i fix cpu speed at 1ghz and everything works
UNTIL I launch mplayer. I've just reproduced this (set governor,
launched mplayer and waited 15-20 mins) and the whole system seems
frozen - just like before. Network is down (no responses to ping). How
to redirect dmesg to serial port? (I'm running 2.6.19 kernel and
8.34.8 fglrx driver.)

Thanks and sorry for 2week delay... (btw - now it is you [ati] who is
responsible for both my cpu and gpu drivers, yes? :D)
