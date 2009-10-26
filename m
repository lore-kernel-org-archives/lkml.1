Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZJZQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZJZQCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZJZQCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:02:42 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:44960 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753204AbZJZQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:02:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P4GD3UG1/r2sbZwy9nZkyWmoSdMQluheReqGrsWaY+bAXi7Nhjg268ydO28BvcnJzJBYOpJ/htigyu4IY+11+bcbgpwxy1G1RrGgKQTgr+qytjP/s9xr7fRCYlseob17;
Date: Mon, 26 Oct 2009 09:02:34 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Peter Stuge <peter@stuge.se>
Cc: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
       linux-kernel@vger.kernel.org, mjg@redhat.com, eric@anholt.net
Subject: Re: no video output after suspend after "drm/i915: force mode set
 at lid open time"
Message-ID: <20091026090234.32ae7656@jbarnes-g45>
In-Reply-To: <20091026015230.6438.qmail@stuge.se>
References: <4AE4BBBC.2070809@gmail.com>
	<20091026015230.6438.qmail@stuge.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 02:52:30 +0100
Peter Stuge <peter@stuge.se> wrote:
> (Before this I tried 2.6.31.1 with KMS, but it didn't do Xv.)
> 
> (Oh, and Xv performance with a83a44+1556c6 is lower than 2.6.30 nofb,
> but that's somewhat secondary. MPlayer performs worse than VLC, but
> both are worse than MPlayer with 2.6.30+2.7.1.)
> 
> Can I help solve this somehow?

I posted a patch that fixed an X40 I was testing:
drm/i915: save/restore BLC histogram control reg across suspend/resume

can you give it a try and see if it works for you?

It may not be related to Riccardo's report, since the above patch isn't
really related to the lid switch problem.

-- 
Jesse Barnes, Intel Open Source Technology Center
