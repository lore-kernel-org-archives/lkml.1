Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbXHHIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbXHHIdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXHHIc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:32:56 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:16093 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750993AbXHHIcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:32:55 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=NWRTkWw9FCnsIg3eZ/g6qHLOImAU0UkzmlTZ14lYYm46MpHZCb9AN1H3ML+qJN1WoZnkEVPcOyytZLvUA2tzKKkDhCqBmkkV9/FS4+uCMeA7j9wsTmg06WwvXtupYwd2;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,234,1183327200"; 
   d="scan'208";a="88011776"
Message-ID: <46B97FB2.1030502@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 10:32:50 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com> <20070807172911.cc626719.akpm@linux-foundation.org>
In-Reply-To: <20070807172911.cc626719.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

thanks a lot for looking at this patch.

> Please feed the diff through scripts/checkpatch.pl.  It finds a lot of issues.

I should have read the latest version of SubmittingPatches :-(
I didn't expect you to pick up this patch so quickly, if I did
I'd have cleaned it more thoroughly. I apologize.

I expect this patch to go through a few more iterations in discussions
with Vivek and other people on this list.

> This is tricky code which you're adding.  Empirically-based stuff derived
> from observation and experimentation.  It is quite impossible for readers
> of this code to work out what the code is doing and why it is doing it
> purely by reading the C statements.

OK. I thought this might make the patch itself too long, that's why I put
it into the header.

Thanks, Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
