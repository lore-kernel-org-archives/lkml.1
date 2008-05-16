Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbYEPRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbYEPRBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYEPRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:01:16 -0400
Received: from testure.choralone.org ([194.9.77.134]:37150 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYEPRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:01:15 -0400
Date: Fri, 16 May 2008 13:01:52 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, travis@sgi.com
Subject: Re: x86-64 NODES_SHIFT compile failure.
Message-ID: <20080516170152.GA7401@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, travis@sgi.com
References: <20080516165456.GA30854@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080516165456.GA30854@codemonkey.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 12:54:56PM -0400, Dave Jones wrote:
 > 4323838215184f5a2f081e0d17b8d60731b03164 added this line to x86's Kconfig..
 > 
 >  config NODES_SHIFT
 >         int
 > +       range 1 15  if X86_64
 >         default "6" if X86_64
 >         default "4" if X86_NUMAQ
 >         default "3"
 > 
 > Selecting 15 causes:
 > 
 > drivers/base/node.c: In function ‘node_read_distance’:
 > drivers/base/node.c:140: error: size of array ‘type name’ is negative
 > 
 > Should the upper limit be reduced to 14 (which compiles), or should
 > the BUILD_BUG_ON be changed to somehow cope with this set of changes?
 
(actually that last part should be s/14/9/ )

	Dave

-- 
http://www.codemonkey.org.uk
