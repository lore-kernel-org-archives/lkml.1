Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXEYXul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXEYXul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 19:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbXEYXuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 19:50:32 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:45594 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbXEYXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 19:50:31 -0400
Subject: Re: [PATCH 1/6] i386/x86_64: Allow disabling the putstr's from
	compressed boot wrapper
From: Ben Collins <ben.collins@ubuntu.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46577112.7090106@zytor.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	 <1180097543.12570.396.camel@cunning> <46573CE4.8080300@zytor.com>
	 <200705251623.55551.jbarnes@virtuousgeek.org>  <46577112.7090106@zytor.com>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 25 May 2007 19:50:53 -0400
Message-Id: <1180137053.12570.446.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 16:28 -0700, H. Peter Anvin wrote:
> Jesse Barnes wrote:
> > 
> > But how often do you have to debug bootloader or compressed boot code?  In 
> > fact, most debug output like this isn't very useful after some initial 
> > debugging, so we usually take it out.  I'm not sure why this would be any 
> > different...
> > 
> 
> You're asking me this?
> 
> I get to hear all the time about some new platform -- sometimes exotic,
> sometimes not -- breaking early boot.

Truth be told, I'd much rather just remove the informational pustr's and
leave the error ones enabled. If it's acceptable, I can just remove
those lines, or make them only work with -DDEBUG.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

