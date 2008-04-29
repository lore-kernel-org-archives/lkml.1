Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYD2TeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYD2TeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYD2TeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:34:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYD2TeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:34:14 -0400
Message-ID: <481777EC.4060601@kernel.org>
Date: Tue, 29 Apr 2008 12:33:00 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Willy Tarreau <w@1wt.eu>, Helge Hafting <helge.hafting@aitel.hist.no>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>	<20080428230524.GK8474@1wt.eu>	<48167A07.4000305@kernel.org>	<20080429050605.GA27875@1wt.eu>	<20080429072911.GA28059@cs181133002.pp.htv.fi>	<20080429081423.GD30507@1wt.eu>	<4816E4FD.5060605@aitel.hist.no>	<20080429100934.GB1473@1wt.eu> <20080429111014.5a065b88@core>
In-Reply-To: <20080429111014.5a065b88@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
>> Funny that you mention Windows. Windows has been using 16-bit unicode
>> for a long time without problems. It's a clean encoding. Like it or not.
> 
> I would describe the UCS-2 situation as a disaster area - embedded nuls
> causing breakage, inability to represent the full unicode space and
> awkward programming interfaces.
> 

Not to mention the fact that UCS-2 ran out of code points almost as soon 
as they said "no more codepoints."  The result was UTF-16, a hideous 
abortion which took all the problems with wide encodings, combined it 
with all the problems of multibyte encodings, and added a few new ones 
for good measure.

	-hpa
