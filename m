Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683AbYABSGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbYABSGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 13:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYABSF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 13:05:59 -0500
Received: from mx0.towertech.it ([213.215.222.73]:59317 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751332AbYABSF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 13:05:58 -0500
Date: Wed, 2 Jan 2008 19:05:37 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: David Brownell <david-b@pacbell.net>
Cc: mingo@elte.hu, kay.sievers@vrfy.org, stern@rowland.harvard.edu,
       rjw@sisk.pl, pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       lenb@kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended 
 (rev. 2)
Message-ID: <20080102190537.2fc735fe@i1501.lan.towertech.it>
In-Reply-To: <20080102175400.3C2E0EF588@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <200801020032.45529.rjw@sisk.pl>
	<20080102105217.GA14731@elte.hu>
	<200801021356.59865.rjw@sisk.pl>
	<20080102131529.GA32160@elte.hu>
	<3ae72650801020655h6ec31ce8n5cd9014c00c9f6ad@mail.gmail.com>
	<20080102160137.GA21046@elte.hu>
	<20080102175400.3C2E0EF588@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jan 2008 09:54:00 -0800
David Bro
> It'd need to have some NTP sync solution for RTC_LIB devices, but
> ISTR the gentime stuff still assumes an update_persistent_clock()
> that doesn't sleep ... and hence can't be used with I2C based RTCs.

 I still believe NTP sync stuff should be done outside of the kernel.
 given the mean accuracy of RTC chips and other sync factors, imho
 you haven't so much to gain with an in-kernel sync code.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

