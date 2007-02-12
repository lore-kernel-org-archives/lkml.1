Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXBLUQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXBLUQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 15:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965302AbXBLUQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 15:16:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbXBLUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 15:16:44 -0500
Date: Mon, 12 Feb 2007 15:16:35 -0500
From: Dave Jones <davej@redhat.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Mark de Vries <mark@asphyx.net>, linux-kernel@vger.kernel.org
Subject: Re: Which CPU for VIA C7/Esther?
Message-ID: <20070212201635.GD10697@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kyle McMartin <kyle@mcmartin.ca>, Mark de Vries <mark@asphyx.net>,
	linux-kernel@vger.kernel.org
References: <1171301858.3557.6.camel@localhost> <20070212191441.GB20686@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212191441.GB20686@athena.road.mcmartin.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 02:14:41PM -0500, Kyle McMartin wrote:
 > On Mon, Feb 12, 2007 at 06:37:38PM +0100, Mark de Vries wrote:
 > > I've been googeling for about an hour now and can't find an answer to:
 > > What type of CPU should I select when compiling a recent 2.6 kernel if I
 > > have a VIA Esther CPU?
 > 
 > > stepping        : 9
 > 
 > config MVIAC3_2
 >         bool "VIA C3-2 (Nehemiah)"
 >         help
 >           Select this for a VIA C3 "Nehemiah". Selecting this enables usage
 >           of SSE and tells gcc to treat the CPU as a 686.
 >           Note, this kernel will not boot on older (pre model 9) C3s.
 > 
 > Is the one you want, I believe.

The C7 doesn't seem to care much which you optimise it for.
Any of the 686 options should work just fine, but MVIAC3_2 is no
worse than any of the others.

		Dave

-- 
http://www.codemonkey.org.uk
