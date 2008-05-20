Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbYETPr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbYETPr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764885AbYETPrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:47:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58701 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761944AbYETPrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Az3mRkan4PbJ5wolpSG+ZD29Ki0RGEanYXgy7dwRvYU4j+lv6T6R2Kh/CKDLLr4I2Fhvpd3oAHa4jAmfSb542ukJM/iRcac8N5aEwDRScX9z4OmLff2GKPC7PAQ57fS2n6JIaolj/vyyyd+ds7Z5QEozmPhXDmcCxCEzIMtLL/s=
Message-ID: <40f323d00805200847t77b2d875j451d0eb9758cf9ff@mail.gmail.com>
Date: Tue, 20 May 2008 17:47:44 +0200
From: "Benoit Boissinot" <bboissin@gmail.com>
To: "Soumyadip Das Mahapatra" <kernelhacker@visualserver.org>
Subject: Re: [PATCH 1/2] bitreversal program
Cc: "Akinobu Mita" <akinobu.mita@gmail.com>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>
	 <1211229736.5915.86.camel@brick>
	 <Pine.LNX.4.64.0805201254240.18899@visualserver.org>
	 <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com>
	 <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 5:25 PM, Soumyadip Das Mahapatra
<kernelhacker@visualserver.org> wrote:
> Thanks for giving a reply Akinobu :-)
> I forgot that bitrev8() is static in header file. Sorry for that.
>
> Below is my new patch considering this. Cant it be applicable?
> Please review it.
>
> I know that my bitrev8() takes more instructions than that
> of yours. But we have to think about faster access of cpu cache over that
> of memory cache(which your bit_rev_table uses).

I didn't review your patch, sorry.
But I'm pretty sure that your patch won't be considered unless you
provide benchmarks
with numbers for different CPU/architecture.
Ideally you should provide a script to test the correctness and the
performance of your
change that anyone could run on his computer.

regards,

Benoit
