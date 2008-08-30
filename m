Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbYH3VtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbYH3VtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 17:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbYH3VtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 17:49:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:42639 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbYH3VtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 17:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=BINsfPiqynylPx6DXTh9GIlWTqsx+SZ+xikqbKWLAhX5HNCeaTsumOytptA0RsM+JF
         4001biXHoVE8MyUkwBWR0Jug3RB2PENMTFiV/fnCCoVqncb7il9/+t86VXUoM+cut2AD
         K5vpNXsEE4imSRM0HbO3V2idp+s9jAosiug+o=
Message-ID: <48B9C052.8090404@tuffmail.co.uk>
Date: Sat, 30 Aug 2008 22:49:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Bug #11237] corrupt PMD after resume
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik> <N8SeMoDzuxC.A.kUG.jkbuIB@albercik>
In-Reply-To: <N8SeMoDzuxC.A.kUG.jkbuIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11237
> Subject		: corrupt PMD after resume
> Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> Date		: 2008-08-02 9:51 (29 days old)
> References	: http://marc.info/?l=linux-kernel&m=121767073424952&w=4
> Handled-By	: Hugh Dickins <hugh@veritas.com>
> 		  Jeremy Fitzhardinge <jeremy@goop.org>
>
>   

This has been isolated (to disparate buggy BIOSes), patches written and
tested.  It's more policy decisions now; mainly whether the workaround
(which wastes 64k) should be applied by default.  So I think you should add

Patch                   :
http://marc.info/?l=linux-kernel&m=122001615314700&w=2

Regards
Alan
