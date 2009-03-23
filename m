Return-Path: <linux-kernel-owner+w=401wt.eu-S1758785AbZCWQUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785AbZCWQUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZCWQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:20:28 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:32557 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbZCWQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:20:28 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=u6VEzqoZ0xsmo7pW94Qghu/cHuHbJQwh8Qx9t+eBA9NkQpeJRCHR1ubW
   hU3P5icebO6x7zd2N4hcPHoRIFo8Ew06MBM6uoKdAv0Kj1G0sQ+bBdG4g
   84ObVzXvlyu4f8d;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,408,1233529200"; 
   d="scan'208";a="64678056"
X-IronPort-AV: E=Sophos;i="4.38,408,1233529200"; 
   d="scan'208";a="45450504"
Message-ID: <49C7B6C7.3070204@fujitsu-siemens.com>
Date: Mon, 23 Mar 2009 17:20:23 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Corey Minyard <minyard@acm.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] limit CPU time spent in kipmid (PREVIOUS WAS BROKEN)
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <20090323153256.GA7528@kroah.com>
In-Reply-To: <20090323153256.GA7528@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Can you make this modifiable at runtime by setting the mode to 0644?
> That way people would not have to unload and then reload the module in
> order to be able to fix their machines, as they usually don't know they
> have a problem until they run their system for a while.

Good point, but let's first sort out if there's agreement about the 
general idea, and do the fine-tuning later. I may actually make sense to 
make this an array parameter so that different IPMI interfaces can have 
different settings (like force_kipmid).

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
