Return-Path: <linux-kernel-owner+w=401wt.eu-S966071AbXCTCr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966071AbXCTCr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 22:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966075AbXCTCr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 22:47:58 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:43920 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966071AbXCTCr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 22:47:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=k0tXGLLbVCm4kKVV75THhcGjA0HhWzp2rEhcfh1fZDSMYF93fOKulOY+jgJLECH3kmoeLDKirYfg9e5otswGTmsnMusPhuI9FIxxwYyaeBRHpgRKhlExBGIXsJNlfbDsLldWGfpf9tzyR21PC7+my7l9GRu6yM5YumZ4opUwePM=  ;
X-YMail-OSG: 2HUTSNwVM1kyIOrN2HwsGISl.OxBypOmWDXPSs0aA6d8R3JS5NxVfgIv0DvjbCPAEG0nTGdbQLUu0YN0jlhvTwsor2PSV1tvrFrnnOakOJufSQhWxRa_TaZdW76D1Ubqfp5EoGMB7rmzme3paWNmOL7efjYLO94iWAJToeQe45Y4JzSsyj8s
Message-ID: <45FF4B59.3060107@yahoo.com.au>
Date: Tue, 20 Mar 2007 13:47:53 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net>	<45FEE33C.1020706@googlemail.com>	<20070319140827.285dcc7f.akpm@linux-foundation.org>	<6bffcb0e0703191437i2ee706d4xaec3bc11ca7c3234@mail.gmail.com>	<20070319175852.c73406f1.akpm@linux-foundation.org> <20070319180234.6b7826b2.akpm@linux-foundation.org>
In-Reply-To: <20070319180234.6b7826b2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 19 Mar 2007 17:58:52 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> 
>>The kernel without Nick's patchset but with the assert runs OK too.  Under
>>the principle of mm-has-been-too-flakey-lately, I'll drop the patches:
>>
>>mm-debug-check-for-the-fault-vs-invalidate-race.patch
>>mm-simplify-filemap_nopage.patch
>>mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
>>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
>>mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
>>mm-merge-nopfn-into-fault.patch
>>mm-merge-nopfn-into-fault-fix.patch
>>mm-remove-legacy-cruft.patch
> 
> 
> ug, too many rejects.  I'll leave them in, minus
> mm-debug-check-for-the-fault-vs-invalidate-race.patch
> 

Hang on a sec... I'll try fixing the thing before you next make a
release.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
