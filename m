Return-Path: <linux-kernel-owner+w=401wt.eu-S965854AbXCPTEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965854AbXCPTEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 15:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965874AbXCPTEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 15:04:25 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:13545 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965854AbXCPTEY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 15:04:24 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
Date: Fri, 16 Mar 2007 14:01:50 -0500
Message-ID: <7D748C767B7FA541A8AC5504A4C89A23015685C4@SAUSEXMB2.amd.com>
In-Reply-To: <C22036DB.BA67%keir@xensource.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the
 hvc console infrastructure for Xen console
Thread-Index: AcdnwmNCoft8fNO1EduhtwAX8io7RQAOxjcg
From: "Huang2, Wei" <Wei.Huang2@amd.com>
To: "Keir Fraser" <keir@xensource.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
cc: xen-devel@lists.xensource.com, "Andi Kleen" <ak@muc.de>,
       linux-kernel@vger.kernel.org, "Keir Fraser" <Keir.Fraser@xensource.com>,
       "Wright" <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       "Ingo Molnar" <mingo@elte.hu>, Chris@smtp.osdl.org
X-OriginalArrivalTime: 16 Mar 2007 19:01:51.0004 (UTC)
 FILETIME=[8DFF15C0:01C767FD]
X-WSS-ID: 69E436153281274506-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But it is shorter than from JFK or Newark. 

-----Original Message-----
From: xen-devel-bounces@lists.xensource.com
[mailto:xen-devel-bounces@lists.xensource.com] On Behalf Of Keir Fraser
Sent: Friday, March 16, 2007 6:58 AM
To: Andrew Morton; Keir Fraser
Cc: xen-devel@lists.xensource.com; Andi Kleen;
linux-kernel@vger.kernel.org; Keir Fraser; Wright;
virtualization@lists.osdl.org; Ingo Molnar; Chris@smtp.osdl.org
Subject: Re: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
console infrastructure for Xen console

On 16/3/07 11:41, "Andrew Morton" <akpm@linux-foundation.org> wrote:

>> It's needed for writing data /after/ reading the consumer index that
shows
>> you have space to write. Looking through xenbus_comms.c I think all
the
>> barriers are correct except there is a spurious extra mb() in
xb_read(),
>> where there is a later rmb() which is sufficient by itself. All the
others
>> have a purpose.
>> 
> 
> If Ingo couldn't work this out from reading the code then nobody else
can,
> and we have a maintainability problem which can only be solved with
> adequate commenting.

Agreed. I've fixed up the commenting, removed the spurious mb(), and I
just
need Jeremy to merge that change into the Xen pv_ops patchset. :-)

 -- Keir


_______________________________________________
Xen-devel mailing list
Xen-devel@lists.xensource.com
http://lists.xensource.com/xen-devel




