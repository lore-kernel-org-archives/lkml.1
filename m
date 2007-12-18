Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXLRU3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXLRU3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbXLRU3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:29:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbXLRU3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:29:06 -0500
Message-ID: <47682D74.9010509@redhat.com>
Date: Tue, 18 Dec 2007 15:28:36 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: James Nichols <jamesnichols3@gmail.com>
CC: Eric Dumazet <dada1@cosmosbay.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>	 <Pine.LNX.4.64.0712180009390.32270@fbirervta.pbzchgretzou.qr>	 <83a51e120712180734i334399dbl51f44fe32d815f7d@mail.gmail.com>	 <Pine.LNX.4.64.0712181704380.4422@fbirervta.pbzchgretzou.qr>	 <83a51e120712180845k6cadf67bn5dd66fb2d3ac72d4@mail.gmail.com>	 <Pine.LNX.4.64.0712181818360.4422@fbirervta.pbzchgretzou.qr>	 <83a51e120712181009pf954f43mcb63ea4dab638458@mail.gmail.com>	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>	 <4768123A.7040603@cosmosbay.com> <83a51e120712181145l75a19e72o3194676b05a855a6@mail.gmail.com>
In-Reply-To: <83a51e120712181145l75a19e72o3194676b05a855a6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2007 02:45 PM, James Nichols wrote:
> 
> I've run tcpdump for all IPs during this problem.  I haven't tried
> doing it for a single explicit IP address- due to the nature of the
> workload it's very difficult to know which IPs will be hit at any
> given moment.   What I did see in the full IP captures is that the
> returning ACKs don't show up in the packet capture.  Unfortunately,
> tcpdump reported that some packets were dropped during the capture.
> Is it possible that the kernel was dropping the packets before they
> could be captured by tcpdump?
> 

The only way to get a reliable trace is to run a capture from a port
mirror on the switch the server is connected to. Capturing from inside
the server at the same time and comparing the traces could be useful.
