Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbZH0FUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbZH0FUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 01:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZH0FUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 01:20:39 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:60697 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbZH0FUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 01:20:39 -0400
Date: Thu, 27 Aug 2009 07:24:23 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Dillow <dave@thedillows.org>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
Message-ID: <20090827052423.GA1709@electric-eye.fr.zoreil.com>
References: <m1prajabk8.fsf@fess.ebiederm.org> <1251232848.9607.15.camel@lap75545.ornl.gov> <m1k50r8u4p.fsf@fess.ebiederm.org> <20090825221903.GA13630@electric-eye.fr.zoreil.com> <m1iqgbknun.fsf_-_@fess.ebiederm.org> <1251294974.14241.9.camel@obelisk.thedillows.org> <1251295175.14241.11.camel@obelisk.thedillows.org> <m11vmy737x.fsf@fess.ebiederm.org> <20090826213024.GA20428@electric-eye.fr.zoreil.com> <m1hbvu45jq.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbvu45jq.fsf@fess.ebiederm.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> Right now I really don't have much more test bandwidth.  So I tried
> for something simple that would address my problem without
> fundamentally changing the already tested logic.

Fair enough.

[...]
> Perhaps we should unconditionally ack everything after changing the 
> interrupt mask  ? If that would prevent races it sounds like a simple
> fix.

I should be able to implement something right this evening, please hold on.

-- 
Ueimor
