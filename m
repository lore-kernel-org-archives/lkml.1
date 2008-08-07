Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYHGUGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYHGUGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYHGUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:06:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYHGUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:06:16 -0400
Date: Thu, 7 Aug 2008 22:06:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jay Lan <jlan@sgi.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>,
       jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080807200659.GJ24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <200808061550.22996.nickpiggin@yahoo.com.au> <489B34BA.4060300@linux-foundation.org> <489B3A0D.7060706@s5r6.in-berlin.de> <489B48BF.3060609@linux-foundation.org> <489B5149.4030600@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489B5149.4030600@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
> hijack panic() before the die calling chain. For KDB or a RAS tool to

Imho kdump should just be fixed to use die chains.

-Andi
