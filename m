Return-Path: <linux-kernel-owner+w=401wt.eu-S932217AbYEBOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217AbYEBOKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYEBOKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:10:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49495 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYEBOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:10:36 -0400
Date: Fri, 2 May 2008 16:10:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Chris Mason <chris.mason@oracle.com>
cc: Jeff Mahoney <jeffm@suse.com>, Tim Gardner <tim.gardner@canonical.com>,
       jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
       kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
Subject: Re: Btrfs v0.14 Released
In-Reply-To: <200805020852.51125.chris.mason@oracle.com>
Message-ID: <alpine.LNX.1.10.0805021609400.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <481A23AB.1020302@suse.com> <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr> <200805020852.51125.chris.mason@oracle.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-05-02 14:52, Chris Mason wrote:
>>
>> An alternative approach, and IMHO better suited, is to:
>>
>> 	make -C ${kdir} all I_HAZ_AN_APPARMOR=1
                       ^
                     M=$PWD

>This is better than the current situation (oops without any clues),

If it oopses, then you probably also get a compile-time warning on
that remove_suid line. And in that case, you can catch it with at least 
a compile-time typecheck so as to not make the user head straight into 
an oops, is not it?
