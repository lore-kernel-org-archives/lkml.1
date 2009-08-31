Return-Path: <linux-kernel-owner+w=401wt.eu-S1751552AbZHaUu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbZHaUu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 16:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZHaUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 16:50:55 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:65227 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZHaUuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 16:50:54 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Aug 2009 16:50:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OPYrP4sfaDXc3Fof9+FnjL9fqRlb1oMAtqX8/tQ76fVEqcTIwRF6bPZ/zVskkEiK/i
         bollI8TZLWSsqohdbnRe+37cPjh7PXDWTMlVBnoRRrCVkoTnlrruUcfUhS+UvqtfEA5P
         5fM7bq70lvid2hACtiZoaUDM0S7cHofuMjY5s=
MIME-Version: 1.0
In-Reply-To: <9EECC02A4CC333418C00A85D21E893260184183346@azsmsx502.amr.corp.intel.com>
References: <4A7AAE07.1010202@redhat.com> <4A878377.70502@redhat.com>
	 <20090816045522.GA13740@localhost>
	 <9EECC02A4CC333418C00A85D21E89326B6611F25@azsmsx502.amr.corp.intel.com>
	 <20090821182439.GN29572@balbir.in.ibm.com>
	 <9EECC02A4CC333418C00A85D21E8932601841832F9@azsmsx502.amr.corp.intel.com>
	 <4A9C2A17.3080802@redhat.com>
	 <9EECC02A4CC333418C00A85D21E893260184183339@azsmsx502.amr.corp.intel.com>
	 <4A9C2E01.7080707@redhat.com>
	 <9EECC02A4CC333418C00A85D21E893260184183346@azsmsx502.amr.corp.intel.com>
Date: Tue, 1 Sep 2009 02:12:44 +0530
X-Google-Sender-Auth: 88d93b284758f637
Message-ID: <661de9470908311342gcdc3eb7v261951221212e549@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
Cc: Rik van Riel <riel@redhat.com>, "Wu, Fengguang" <fengguang.wu@intel.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 1, 2009 at 1:41 AM, Dike, Jeffrey G<jeffrey.g.dike@intel.com> wrote:
>> Page discards by the host, which are invisible to the guest
>> OS.
>
> Duh.  Right - I can't keep my VM systems straight...
>

Sounds like we need a way of indicating reference information. Guest
page hinting (cough; cough) anyone? May be a simpler version?

Balbir Singh.
