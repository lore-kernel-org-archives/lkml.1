Return-Path: <linux-kernel-owner+w=401wt.eu-S1764640AbYB1V0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764640AbYB1V0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764206AbYB1V0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:26:13 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:19446 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764190AbYB1V0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:26:11 -0500
X-Belgacom-Dynamic: yes
Date: Thu, 28 Feb 2008 22:26:09 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Roland Dreier <rdreier@cisco.com>
Cc: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
Message-ID: <20080228212609.GB12382@infomag.infomag.iguana.be>
References: <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de> <20080227203655.GA30054@elte.hu> <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de> <alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de> <ada3areyu7x.fsf@cisco.com> <E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net> <adamypmx7k1.fsf@cisco.com> <E14D1C2A44812C4F9C3ED321127EDF6505829D5D6C@G3W0854.americas.hpqcorp.net> <adaejaxx9p7.fsf_-_@cisco.com> <ada7igox1jx.fsf_-_@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7igox1jx.fsf_-_@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

> We can fix this by simply deleting all of the duplicated DMI table
> walking code and using the kernel's existing dmi_walk() interface to
> find the DMI entry the driver is looking for.

:-) This was the intention for next week :-) You beat me to it.

Greetings,
Wim.

