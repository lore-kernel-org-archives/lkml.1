Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbXLJSEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbXLJSEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbXLJSEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:04:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbXLJSEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:04:43 -0500
Date: Mon, 10 Dec 2007 13:04:38 -0500
From: Dave Jones <davej@redhat.com>
To: Alexander Rajula <chris@nerdmail.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: /proc/cpuinfo reports erroneous CPU frequency.
	(2.6.23 & 2.6.22)
Message-ID: <20071210180438.GA22488@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexander Rajula <chris@nerdmail.nu>, linux-kernel@vger.kernel.org
References: <475C9B06.9000901@nerdmail.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475C9B06.9000901@nerdmail.nu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 02:48:54AM +0100, Alexander Rajula wrote:
 > While using 2.6.23 and 2.6.22 (earlier kernels have not been tested) /proc/cpuinfo reports the wrong CPU frequency:
 > 
 > 
 > While overclocking an AMD Athlon X2 (2GHz) CPU /proc/cpuinfo reports the wrong CPU frequency.
 > I am quite puzzled by this.
 > Is this an error in the kernel, or is there something strange going on?

cpu frequency scaling relies on static tables in the BIOS that contain
a bunch of predefined frequencies. When you overclock, you're running
at frequencies that aren't in these tables.  Everything falls apart as a result.

There's nothing here to fix, don't overclock.

	Dave

-- 
http://www.codemonkey.org.uk
