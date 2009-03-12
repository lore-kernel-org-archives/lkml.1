Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZCLOqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZCLOqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 10:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbZCLOqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 10:46:11 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:51771 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbZCLOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 10:46:10 -0400
From: Frans Pop <elendil@planet.nl>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [BUG,2.6.29-rc7,s390] System goes into endless loop during boot or logon
Date: Thu, 12 Mar 2009 15:46:04 +0100
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390@vger.kernel.org,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080835.14032.elendil@planet.nl> <200903091025.53284.elendil@planet.nl> <1236871686.19544.3.camel@localhost.localdomain>
In-Reply-To: <1236871686.19544.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903121546.06687.elendil@planet.nl>
X-OriginalArrivalTime: 12 Mar 2009 14:46:07.0251 (UTC) FILETIME=[46B86E30:01C9A321]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Jan Glauber wrote:
> > AFAICT s390 does not have an NMI watchdog. And I have no idea how I
> > could trigger a sysrq given that I can't login and only have a dumb
> > console or SSH session to work with anyway.
>
> You can try to trigger sysrq by ^-, so to get the task view type: .^-t

Thanks a lot Jan! On a running system that works, so now the only question 
is if it also works when the system is looping. Will try later.
