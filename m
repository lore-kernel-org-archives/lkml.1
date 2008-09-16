Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbYIPOBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbYIPOBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYIPOBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:01:03 -0400
Received: from ns.firmix.at ([62.141.48.66]:2048 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbYIPOBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:01:01 -0400
Subject: Re: looking for a function
From: Bernd Petrovitsch <bernd@firmix.at>
To: Xu Yang <risingsunxy@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
References: <ab40e9c0809160550q411507aeledae30a9f835d09d@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 16 Sep 2008 16:00:32 +0200
Message-Id: <1221573632.6103.83.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.347 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.347 required=5
X-Spam-Score: -2.347 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, 2008-09-16 at 14:50 +0200, Xu Yang wrote:
> Hi guys,
> 
> I am looking for a function that can show me the current thread is
> running on which cpu.

> e.g I am using pthread to write a multithreaded program, in each
> thread I would like to insert such kind of function so that I can know
> on which cpu this thread is running on.

That doesn't make much sense as the same thread can run on a different
CPU after each scheduling decision. And - as it is in userspace -
scheduling can happen before any assembler op.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


