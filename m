Return-Path: <linux-kernel-owner+w=401wt.eu-S1757388AbZGILVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388AbZGILVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755674AbZGILVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:21:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbZGILVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:21:00 -0400
Date: Thu, 9 Jul 2009 13:20:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <20090708065325.GE3309@dtor-d630.eng.vmware.com>
Message-ID: <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Dmitry Torokhov wrote:

> > Are you seeing with a specific keyboard type(s), or is this a general 
> > problem? Could you confirm whether it is specific either to PS2 or USB 
> > keyboards only, or it does happen for both?
> Can't think of any input chnages in this timeftrame that would cause
> such effect. Maybe TTY changes?

By the way, if I understand it correctly, Andi is able to see the very 
same effect even inside X, so tty can be possibly ruled out, right?

Still, I don't see the leaking F key in the evtest output (see the mail 
from yesterday), which is quite puzzling.

-- 
Jiri Kosina
SUSE Labs
