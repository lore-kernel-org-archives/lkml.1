Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYABSNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYABSNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYABSNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:13:01 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:25641 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752411AbYABSM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:12:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=AyiT/lnoZvJJzI1939Qolv4ntrWGcPr3HrauuKB9kwSCofa+W4uSsr+sDlxxNzqo/TgMQwbNXk5ppdwBbfiKGheAPhCQHEqG2Unr3oA+vg6ewmuQiEZMEoEnVbT0Xo8POvspvbu/HdKK+OW4RX/gYLG0iPbWYUpxf2FCg36OIJM=  ;
X-YMail-OSG: 6otsP_4VM1lrfcI37gwAphRNOdBd2BpK0SC6EvaXgQG3TmhpL.kikN3KcaANAp1T9m5kMD5ueQ--
Date: Wed, 02 Jan 2008 10:12:54 -0800
From: David Brownell <david-b@pacbell.net>
To: alessandro.zummo@towertech.it
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended 
 (rev. 2)
Cc: stern@rowland.harvard.edu, rjw@sisk.pl, pavel@suse.cz, mingo@elte.hu,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, kay.sievers@vrfy.org,
       gregkh@suse.de, akpm@linux-foundation.org
References: <200801020032.45529.rjw@sisk.pl>
 <20080102105217.GA14731@elte.hu> <200801021356.59865.rjw@sisk.pl>
 <20080102131529.GA32160@elte.hu>
 <3ae72650801020655h6ec31ce8n5cd9014c00c9f6ad@mail.gmail.com>
 <20080102160137.GA21046@elte.hu>
 <20080102175400.3C2E0EF588@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20080102190537.2fc735fe@i1501.lan.towertech.it>
In-Reply-To: <20080102190537.2fc735fe@i1501.lan.towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080102181254.3469E28CE0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It'd need to have some NTP sync solution for RTC_LIB devices, but
> > ISTR the gentime stuff still assumes an update_persistent_clock()
> > that doesn't sleep ... and hence can't be used with I2C based RTCs.
>
> I still believe NTP sync stuff should be done outside of the kernel.
> given the mean accuracy of RTC chips and other sync factors, imho
> you haven't so much to gain with an in-kernel sync code.

Then the kernel/time/ntp.c stuff should be removed on all systems?
