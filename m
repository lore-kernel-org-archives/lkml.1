Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbXKPOPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbXKPOPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759485AbXKPOPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:15:08 -0500
Received: from main.gmane.org ([80.91.229.2]:33673 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759481AbXKPOPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:15:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0
Date: Fri, 16 Nov 2007 15:13:01 +0100
Message-ID: <m3r6iqffde.fsf@ursa.amorsen.dk>
References: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com> <20071115.152813.89410917.davem@davemloft.net> <cac0ab7d0711160030w149c7a7s2db55ac56d0a05cc@mail.gmail.com> <20071116.010548.94286711.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Cancel-Lock: sha1:RsP8v45WmLMwkmW6bGpNWJAkmek=
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "DM" == David Miller <davem@davemloft.net> writes:

>> Reply:
>> Opcode: reply (0x0002)
>> Sender HW: 00:AA.00:AA:00:AA
>> Sender IP:   192.168.0.1
>> Target HW:  00:AA:00:AA:00:AA
>> Target IP:    192.168.0.1

DM> And this is exactly a sensible response in my opinion.

Why send the reply at all? Sending a unicast packet with yourself as
destination MAC seems a bit useless. Do switches propagate it?


/Benny


