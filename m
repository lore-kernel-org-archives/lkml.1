Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbZGILaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbZGILaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 07:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZGIL35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 07:29:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:52216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZGIL35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 07:29:57 -0400
Date: Thu, 9 Jul 2009 13:29:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
In-Reply-To: <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de>
Message-ID: <alpine.LNX.2.00.0907091328370.27327@wotan.suse.de>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907081317000.27327@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Jiri Kosina wrote:

> For completness, Andi sent me the following evtest output off-list 
> yesterday. The LeftAlt being autorepeated at time 1246964430.448470 is a 
> little bit suspicious, as it is preceeded by release ... I don't see how 
> this could be causing the behavior Andi is observing though.
> 
> I am not able to reproduce the problem myself.

Umm, actually, Andi, could you verify whether reverting e7b5c1ef4d changes 
the behavior you are observing in any way?

-- 
Jiri Kosina
SUSE Labs
