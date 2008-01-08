Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYAHTQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYAHTQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYAHTQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:16:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33640 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbYAHTQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:16:17 -0500
Date: Tue, 8 Jan 2008 20:18:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108191843.GA1004@one.firstfloor.org>
References: <20080108164015.GC31504@one.firstfloor.org> <20080108185255.GA4627@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108185255.GA4627@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, Andi! I think it'd very useful change.

Reminds me this is something that should be actually flagged
in checkpatch.pl too

Andy, it would be good if checkpatch.pl complained about .ioctl = 
as opposed to .unlocked_ioctl = ...

Also perhaps if a whole new file_operations with a ioctl is added
complain about missing compat_ioctl as a low prioritity warning?
(might be ok if it's architecture specific on architectures without
compat layer) 

-Andi
