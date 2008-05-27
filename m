Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYE0Ut2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYE0Ut2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759123AbYE0UtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:49:12 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:38470 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759305AbYE0UtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:49:10 -0400
Date: Tue, 27 May 2008 16:48:58 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: vt, make sysfs operations atomic
Message-ID: <20080527204858.GI5713@cathedrallabs.org>
References: <1211802812-13658-1-git-send-email-jirislaby@gmail.com> <20080527194357.GA12185@cathedrallabs.org> <483C6EAE.4050401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C6EAE.4050401@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> the reason for the code be the way it is is because vcs_{add,remove}_sysfs()
>> may sleep
>
> What's the point? To have races in the code but not sleep inside the semaphore?
what about fixing the code to remove the race _and_ not sleep inside the
semaphore? :)

-- 
Aristeu

