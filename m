Return-Path: <linux-kernel-owner+w=401wt.eu-S1751217AbZGMEFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbZGMEFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 00:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZGMEFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 00:05:34 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:42126 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZGMEFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 00:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rq8hS7aaX7rkTMgWuJ70UJFFlibVMyufj1TtGjvE+c2I383aoss5Qnl82Aclb6X3db
         KyTqgBAWUCyTSCu7RwOCZcW0DfDQkZyBrdSEuU/i+mIRXW3FWYnzFCpFgF+f/NjwA/BA
         jM2Ts9TTTwIYOBr10CIkpiNodnktEuD9MSLpY=
Date: Sun, 12 Jul 2009 21:05:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20090713040528.GH10819@dtor-d630.eng.vmware.com>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de> <20090708065325.GE3309@dtor-d630.eng.vmware.com> <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907091319480.27327@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 01:20:56PM +0200, Jiri Kosina wrote:
> On Tue, 7 Jul 2009, Dmitry Torokhov wrote:
> 
> > > Are you seeing with a specific keyboard type(s), or is this a general 
> > > problem? Could you confirm whether it is specific either to PS2 or USB 
> > > keyboards only, or it does happen for both?
> > Can't think of any input chnages in this timeftrame that would cause
> > such effect. Maybe TTY changes?
> 
> By the way, if I understand it correctly, Andi is able to see the very 
> same effect even inside X, so tty can be possibly ruled out, right?
> 

Umm, doesn't SuSE still use legacy keyboard driver instead of evdev in
X? Thomas mentioned recently it still did...

-- 
Dmitry
