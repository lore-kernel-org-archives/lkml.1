Return-Path: <linux-kernel-owner+w=401wt.eu-S1763180AbZCXRQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763180AbZCXRQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 13:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762808AbZCXRPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 13:15:37 -0400
Received: from dgate10.fujitsu-siemens.com ([80.70.172.49]:42953 "EHLO
	dgate10.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763006AbZCXRPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 13:15:35 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=gMYpf+hrEYX3zm/ZDJqDYGxlUwiOJHdaxDa/QVbrLLlT64n2+6vrJooy
   vi6Sv1XJ6VDNSPupQbqeD7zavfM0qy9FCtKdpeXuJIhAp+U4Y8wwWM7S7
   hlxI5SD2M5UGGDE;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,413,1233529200"; 
   d="scan'208";a="64856168"
X-IronPort-AV: E=Sophos;i="4.38,413,1233529200"; 
   d="scan'208";a="50067225"
Message-ID: <49C91533.9070004@fujitsu-siemens.com>
Date: Tue, 24 Mar 2009 18:15:31 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: Corey Minyard <minyard@acm.org>, Greg KH <greg@kroah.com>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Openipmi-developer] Improving IPMI performance under load
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org> <49C8A823.6020809@fujitsu-siemens.com> <49C8DB54.4010200@acm.org> <20090324155035.GB16332@auslistsprd01.us.dell.com>
In-Reply-To: <20090324155035.GB16332@auslistsprd01.us.dell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Domsch wrote:

> I still get complaints from users who see their CPU utilization spike
> attributed to kipmi0 when userspace throws a lot of requests down to
> the controller.  I've seen them want to limit kipmi0 even further, not
> speed it up.

My first patch ("limit CPU time spent in kipmi") is targeted at exactly 
those users that you are talking about.

These users make their observations on idle systems. You'll never see 
kipmid use up CPU under "top" in systems with high CPU load. With the 
new patch I have in mind, kipmid can be tuned to be faster under load 
and at the same time use less cycles (at the cost of slightly decreased 
speed) when idle.

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
