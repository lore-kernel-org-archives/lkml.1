Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbYJ1Aoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbYJ1Aoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYJ1AoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:44:25 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1684 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYJ1AoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:44:24 -0400
Subject: Re: [PATCH 1/8] Add scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       randy.dunlap@oracle.com, pavel@suse.cz, ukleinek@strlen.de
In-Reply-To: <20081027155254.a710c779.akpm@linux-foundation.org>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
	 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
	 <20081027155254.a710c779.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 17:44:15 -0700
Message-Id: <1225154655.5269.118.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:52 -0700, Andrew Morton wrote:
> otoh, we'll sometimes also want the
> 
> 	joe@perches.com,akpm@linux-foundation.org

Oh, if you want addresses without the proper name, use the --no-n option

$ ./scripts/get_maintainer.pl -f --no-n --no-multiline drivers/net/b44.c
Larry.Finger@lwfinger.net, jeff@garzik.org, jgarzik@pobox.com, linville@tuxdriver.com, mb@bu3sch.de, mboton@gmail.com, netdev@vger.kernel.org, zambrano@broadcom.com

Oh[2]: And you've got to add --git-chief-penguins to get you and Linus onto the list

./scripts/get_maintainer.pl --git-chief-penguins -f --no-n --no-multiline drivers/net/b44.c
Larry.Finger@lwfinger.net, akpm@linux-foundation.org, jeff@garzik.org, jgarzik@pobox.com, linville@tuxdriver.com, mb@bu3sch.de, mboton@gmail.com, netdev@vger.kernel.org, torvalds@linux-foundation.org, zambrano@broadcom.com


