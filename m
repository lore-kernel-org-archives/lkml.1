Return-Path: <linux-kernel-owner+w=401wt.eu-S1422813AbXCWLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422813AbXCWLZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 07:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422817AbXCWLZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 07:25:52 -0400
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:58657 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422813AbXCWLZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 07:25:50 -0400
Subject: Re: Question about CPU flags detection
From: Arjan van de Ven <arjan@linux.intel.com>
To: hutuworm <hutuworm@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f4e165120703230304p333124abmf7cce66d73a170fa@mail.gmail.com>
References: <f4e165120703230304p333124abmf7cce66d73a170fa@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Mar 2007 12:25:40 +0100
Message-Id: <1174649140.1158.230.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 18:04 +0800, hutuworm wrote:
> Hi all,
> 
> I just installed Red Hat Enterprise Linux AS release 4 (Nahant Update
> 4) on a Dell PE1950 server, which has two of dual-core Xeon 5110
> 1.6GHz CPUs. According to the processor spec @
> http://processorfinder.intel.com/details.aspx?sSpec=SL9RZ , it doesn't
> support Hyper-threading technology, but both 'cat /proc/cpuinfo | grep
> ' and 'dmidecode | grep -A 30 Flags' commands show there're "ht" or
> "HTT (Hyper-threading technology)" available.


the "ht" flag there ONLY means "we support reporting the number of
threads/cores/etc via the MSRs". It does not mean that you actually have
hyperthreading, only that your cpu knows how to report what it
supports...


I hope this answer helps,
   Arjan van de Ven
