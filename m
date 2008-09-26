Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYIZMWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYIZMWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYIZMWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:22:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37091 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbYIZMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:22:21 -0400
Date: Fri, 26 Sep 2008 06:22:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Jing Huang <huangj@brocade.com>, James.Bottomley@hansenpartnership.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rvadivel@brocade.com, srayas@brocade.com, vravindr@brocade.com
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2nd try)
Message-ID: <20080926122219.GV27204@parisc-linux.org>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com> <200809260841.39433.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809260841.39433.eike-kernel@sf-tec.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 08:41:31AM +0200, Rolf Eike Beer wrote:
> You should use pcim_enable_device(). This would help you by simplifying your 
> error and release code as it keeps track of freeing a bunch of resources. See 
> Documentation/driver-model/devres.txt.

I hate the devres stuff.  It takes care of most things behind your back,
but is terribly complex code and makes bugs next to impossible to track
down.  Don't add more users for it unless you really, really have to.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
