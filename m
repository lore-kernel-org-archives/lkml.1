Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbZGWVG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbZGWVG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 17:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZGWVGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 17:06:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48918 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZGWVGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 17:06:25 -0400
Date: Thu, 23 Jul 2009 17:06:16 -0400
From: Dave Jones <davej@redhat.com>
To: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
Cc: linux-kernel@vger.kernel.org
Subject: Re: max freq is 2.1, but current freq is between min.
Message-ID: <20090723210616.GB18811@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>,
	linux-kernel@vger.kernel.org
References: <200907231936.n6NJakbL003030@indigo.cs.bgu.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907231936.n6NJakbL003030@indigo.cs.bgu.ac.il>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 10:36:46PM +0300, eial@cs.bgu.ac.il wrote:
 > 
 > I have a t8100 cpu, running gentoo, I've tried both kernels 2.6.29 and 30, but for no avail.
 > I have 4 stepping: 2.10 GHz, 2.10 GHz, 1.60 GHz, 1.20 GHz but under all governors, the max freq is 1.2 it changes here and there: cpufreq-info shows this:
 > ..
 >   current policy: frequency should be within 1.20 GHz and 1.20 GHz.                     <----- range is not ok
 > ..
 > the range keeps changing, due this thing, it took e 6 and a half hours to compile openoffice, almost twice than the average time that I have compiled it before.
 > most of the time, the computer is unusable.I have no idea what else can be done, I've checked the bios, all ok, that is the latest version of bios, running boinc, compile and checking for broken libs keeps the freq at min...

Boot with cpufreq.debug=7 and you should see notices in your dmesg when the
upper bound is being limited.  This usually happens when the BIOS tells us
the system is overheating. As it cools off, the higher speeds should become
available again.

	Dave

