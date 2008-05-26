Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYEZIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYEZIcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYEZIcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:32:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:50653 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYEZIcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:32:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V2++cCELif/JHS4BMQidabwaJLusxLEo5dabKJMRpNZKV5MW6QAdjYhLM/CjjjRARc0oJTu3/WTWqbm2x1amvq+sUfR6PBK27hzoshORzUYMA5o2rzG1UfQLHqWFBuCMtjprZESMn//NiE7I5nLxgeqnPjsF6i5ge7COaDclg40=
Message-ID: <b637ec0b0805260131v480d3f3cjb58ce673729c653a@mail.gmail.com>
Date: Mon, 26 May 2008 10:31:57 +0200
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch on latest git
Cc: sam@ravnborg.org
In-Reply-To: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the config is the right one, the name I gave it is wrong.
It should be config-2.6.26-rc3-00436-gb373303



On Mon, May 26, 2008 at 10:03 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi.
> I don't know it it has been reported already:
>
> WARNING: vmlinux.o(.text+0x114bb): Section mismatch in reference from
> the function nopat() to the function .cpuinit.text:pat_disable()
> The function nopat() references
> the function __cpuinit pat_disable().
> This is often because nopat lacks a __cpuinit
> annotation or the annotation of pat_disable is wrong.
>
> Config is in attachment.
>
> Thanks,
> Fabio
>
