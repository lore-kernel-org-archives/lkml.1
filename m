Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXJLNtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXJLNtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXJLNtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:49:40 -0400
Received: from stinky.trash.net ([213.144.137.162]:59027 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbXJLNti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:49:38 -0400
Message-ID: <470F7B4B.2010609@trash.net>
Date: Fri, 12 Oct 2007 15:48:59 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Al Boldi <a1426z@gawab.com>,
       Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
       netdev@vger.kernel.org, linux-net@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] iptables:  mangle table obsoletes filter table
References: <200710120031.42805.a1426z@gawab.com> <Pine.LNX.4.64.0710121449370.23981@fbirervta.pbzchgretzou.qr> <200710121630.29151.a1426z@gawab.com> <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710121533360.23981@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 12 2007 16:30, Al Boldi wrote:
>>>>
>>>>With the existence of the mangle table, how useful is the filter table?
>>>
>>>A similar discussion was back in March 2007.
>>>http://marc.info/?l=netfilter-devel&m=117394977210823&w=2
>>>http://marc.info/?l=netfilter-devel&m=117400063907706&w=2
>>>
>>>in the end, my proposal was something like
>>>http://jengelh.hopto.org/GFX0/nf_proposal2.svg
>>
>>Any chance you could publish this as something readable like text/html?
> 
> 
> Like, image/png?
> http://jengelh.hopto.org/GFX0/nf_proposal2.png


The netlink based iptables successor I'm currently working on allows to
dynamically create tables with user-specified priorities and "built-in"
chains. The only built-in tables will be those that need extra
processing (mangle/nat). So it should be possible to set up tables
basically any way you desire.



