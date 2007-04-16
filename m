Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbXDPGcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbXDPGcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbXDPGcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:32:16 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:13360 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020AbXDPGcP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:32:15 -0400
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Machine Check Exception on Opteron 265
Date: Mon, 16 Apr 2007 08:31:48 +0200
User-Agent: KMail/1.9.6
cc: "Drift@tihlde" <drift@tihlde.org>, linux-kernel@vger.kernel.org
References: <fa.bATEBhtZlyN0K1NKutzIYJJSRC0@ifi.uio.no>
 <4620F5B0.6050704@shaw.ca>
In-Reply-To: <4620F5B0.6050704@shaw.ca>
MIME-Version: 1.0
Message-ID: <200704160831.48974.joachim.deguara@amd.com>
X-OriginalArrivalTime: 16 Apr 2007 06:31:51.0761 (UTC)
 FILETIME=[EB29C410:01C77FF0]
X-WSS-ID: 6A3DC7D72EG5414547-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 April 2007 17:39:28 Robert Hancock wrote:
> Espen Fjellvær Olsen wrote:
> > As far as we know there wasnt any unuasal activity on the server at the
> > time.
> > We updated glibc yesterday, but that shouldnt really cause such a
> > problem. So now we wonder if this might be an MCE bug, or really a HW
> > problem, and if it is one of the CPUs, or the RAM thats faulty.
> > We are running 2.6.18.
>
> Sounds like some bad RAM..

Clearly.  I would run memtest-86+[1] for a night and you should see the bad 
DIMM.  You can try the new feature in version 1.70 of that tool to display 
the DMI name of the DIMM to attempt to locate the exact DIMM.  That option is 
under Error Reporting menu.

-Joachim

[1] http://memtest.org/


