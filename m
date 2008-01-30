Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYA3I51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYA3I51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759284AbYA3Iyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:54:52 -0500
Received: from main.gmane.org ([80.91.229.2]:52250 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759267AbYA3Iyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:54:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: ndiswrapper and GPL-only symbols redux
Date: Wed, 30 Jan 2008 08:54:31 +0000
Message-ID: <yw1xsl0f3d88.fsf@mansr.com>
References: <1201641765.18773.35.camel@dv> <1201652420.2271.91.camel@perihelion> <1201657701.24898.14.camel@dv> <20080130050424.GA22444@dallas.jonmasters.org> <47A00D43.60602@acm.org> <Pine.LNX.4.64.0801300838550.12371@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:mnIpUWD17a5QTZ9R3QIafo2YF1E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Tue, 29 Jan 2008, Zan Lynx wrote:
>> Jon Masters wrote:
>> > I wouldn't quite say that. I wasn't going to comment, but...personally,
>> > I actually disagree with the assertions that ndiswrapper isn't causing
>> > proprietary code to link against GPL functions in the kernel (how is
>> > an NDIS implementation any different than a shim layer provided to
>> > load a graphics driver?), but I wasn't trying to make that point.
>> 
>> Well, as long as *any* part of the kernel ever links to proprietary
>> code, then GPL functions link to it in exactly the same way
>> ndiswrapper enables.  It's only a matter of how many steps of
>> separation.
>> 
>> A perfectly GPL USB network driver linked to GPL-only functions
>> feeds data into the kernel where it swirls about and emerges from a
>> proprietary network filesystem driver, for example.
>
> A proprietary network filesystem driver _on a different system_, you
> mean? In this case the proprietary code has no direct access to your
> kernel data, except through the communication protocol. No tainting is
> involved, as all corruption in your kernel is caused by kernel bugs in
> visible code that can be debugged.

Untrusted code doesn't necessarily violate the GPL.  The two issues
are orthogonal.

-- 
Måns Rullgård
mans@mansr.com

