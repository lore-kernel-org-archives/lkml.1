Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYGPQgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYGPQgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbYGPQg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:36:27 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19805 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYGPQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:36:26 -0400
X-IronPort-AV: E=Sophos;i="4.30,374,1212364800"; 
   d="scan'208";a="127514795"
From: Roland Dreier <rdreier@cisco.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jie Yang <Jie.Yang@Atheros.com>, "jeff\@garzik.org" <jeff@garzik.org>,
       David Miller <davem@davemloft.net>,
       "jcliburn\@gmail.com" <jcliburn@gmail.com>,
       "parag.warudkar\@gmail.com" <parag.warudkar@gmail.com>,
       Willy Tarreau <w@1wt.eu>,
       "oliver.schuster\@schweigstill.de" <oliver.schuster@schweigstill.de>,
       "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
References: <72981EBCFD196144B7C6999B9FC34A9A3EE60E9F58@SHEXMB-01.global.atheros.com>
	<20080715211514.25848d8a@extreme>
	<72981EBCFD196144B7C6999B9FC34A9A3EE60EA59C@SHEXMB-01.global.atheros.com>
	<20080716085329.03e97b2a@extreme>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Jul 2008 09:36:24 -0700
In-Reply-To: <20080716085329.03e97b2a@extreme> (Stephen Hemminger's message of
	"Wed, 16 Jul 2008 08:53:29 -0700")
Message-ID: <adafxq9bxbr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2008 16:36:25.0162 (UTC) FILETIME=[169342A0:01C8E762]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Output of checkpatch (scripts/checkpatch.pl in kernel source).
 > Personally, I am not a whitespace bigot, and don't think
 > all the warnings in checkpatch have to be fixed.
 > 
 > ----------
 > ERROR: patch seems to be corrupt (line wrapped?)
 > #121: FILE: drivers/net/atl1e/atl1e.h:9:
 > ree
 > 
 > WARNING: space prohibited between function name and open parenthesis '('
 > #212: FILE: drivers/net/atl1e/atl1e.h:97:
 > +       _tpd =3D (((_vlan) << (4)) | (((_vlan) >> 13) & 7) |\

It's kind of pointless to run checkpatch on a corrupted patch (the email
was quoted-printable and you didn't decode it back to text).  Of course
it's also better to send non-mangled patches.

 - R.
