Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYC1G6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYC1G6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 02:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYC1G61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 02:58:27 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:22745 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754121AbYC1G60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 02:58:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=08Z4IzMlD3G1oCs1Z+BQg4DAokJMaYKu8Su2TBVGo3MMs+oveOCG5gYrxfJ5cUSJIZi5c+FsNZu20aVz35hphAeDD8Z1XNduHKCTph9ddcZiu7XqOn/g7801po5WylLQZWSPCnLSUJ4v0A86EerTUqcJFm4Eo0tK/KxzICI9LD4=  ;
X-YMail-OSG: N0wY26QVM1kGKFvZMHShQKnexcIn6eZWdVWHv5MqL1Auqxxu4NM.o6.aufaDpPs0usC9If.f.g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7: Ugh.
Date: Thu, 27 Mar 2008 23:58:19 -0700
User-Agent: KMail/1.9.6
Cc: David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
References: <20080327160700.GB828@suse.de> <47EC8793.2040508@rtr.ca> <47EC8AC3.7080002@rtr.ca>
In-Reply-To: <47EC8AC3.7080002@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803272358.20081.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 March 2008, Mark Lord wrote:
> Could somebody please fix the RTC mess in kconfig now ?

My version has been sitting in MM for a while now.
I'll forward it to you off-list, in case you want
to verify that it resolves that specific issue.

It would have prevented your broken initial config,
which statically linked both the new framework plus
some incompatible legacy stuff.

- Dave
