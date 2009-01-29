Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZA2TzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZA2TzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:55:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZA2Ty6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:54:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZA2Ty5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:54:57 -0500
Date: Thu, 29 Jan 2009 14:54:47 -0500
From: Dave Jones <davej@redhat.com>
To: Xiaoning Ding <dingxn@ymail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org
Subject: Re: a question about p4_clockmod module on Xeon quad core
	processors
Message-ID: <20090129195447.GA14636@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Xiaoning Ding <dingxn@ymail.com>, Michael Tokarev <mjt@tls.msk.ru>,
	linux-kernel@vger.kernel.org
References: <20090129172406.GB14096@redhat.com> <279321.76517.qm@web59906.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <279321.76517.qm@web59906.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:40:25AM -0800, Xiaoning Ding wrote:

 > Thanks for the explanation. So the conclusion is that ACPI-cpufreq
 > can reduce power consumption by lowering cpu frequencies, and
 > p4-clockmod can hardly save power because CPU frequences are not
 > changed.

yes. and also that it inhibits entering deeper C states for longer periods.

 > My experiments do not consider power consumption. It only requires to
 > slow down the speed of some cores by either reducing frequencies or
 > clock modulation. In such case, p4-clockmod is still a good choice for
 > me. Can anyone give me some hints on whether p4-clockmod works on Xeon
 > quad-core processors, and how to get it work?

I'm not sure if the registers are still there on quad cores, but I
would be surprised if they weren't.  Hitting them directly with
msr tools is probably the best way, or writing a small program
that manipulates /dev/cpu/*/msr directly.

	Dave

-- 
http://www.codemonkey.org.uk
