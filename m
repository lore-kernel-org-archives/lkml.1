Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYDIIlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYDIIlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYDIIlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:41:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46452 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYDIIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:41:39 -0400
Date: Wed, 9 Apr 2008 10:46:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409084606.GD19010@one.firstfloor.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <87ej9gp6ol.fsf@basil.nowhere.org> <20080409081943.GI17915@shadowen.org> <20080409083013.GJ17915@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409083013.GJ17915@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, and if people felt that the concensus was for something to be
> implemented and that you are waiting for me to implement the change in
> checkpatch; please say so.

Well at least I think the printk change is a good one to implement and there 
wasn't much protest to it at least.

If you're looking for another change request I think dropping the trailing
white space check would be good a idea because a lot of maintainers already
handle that automatically and it is not really worth bothering the "leaf
developers" with because that can be trivially automated.

Also I still think --file needs to go, or at least be replaced with
--file-force and warning. See the recent unpleasant incident it caused
again, e.g.

http://thread.gmane.org/gmane.linux.kernel/656847/focus=657003
and 
http://thread.gmane.org/gmane.linux.kernel/656847/focus=657003

-Andi

