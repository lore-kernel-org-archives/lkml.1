Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbZGHGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbZGHGxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZGHGxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:53:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:53532 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759570AbZGHGxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=yA5kFrfvxKfCMAOMNrByg9cQVg1qHkCLtTl8TywhlbIoITSawJsROYHIAuHDeAYbID
         A/6O3tPyc3jPlTYTajqCHJ31XsqmDHyU8848K0p6OXIuDeO4e9JpMeTezEZKkWUPOjWz
         /KFucgyowXWdEVVAzX9WeMt8h1KCyGI6Teg/A=
Date: Tue, 7 Jul 2009 23:53:25 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, rjw@sisk.pl, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.30 leaking keys on console switch
Message-ID: <20090708065325.GE3309@dtor-d630.eng.vmware.com>
References: <87eiss7uhb.fsf@basil.nowhere.org> <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0907071048210.4994@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 10:50:01AM +0200, Jiri Kosina wrote:
> 
> [added Dmitry to CC]
> 
> On Tue, 7 Jul 2009, Andi Kleen wrote:
> 
> > One new issue I see in 2.6.30 (I think I saw it in some rc*s) too is 
> > that console switch often leaks the Fkey of the console switch into the 
> > target console.
> > 
> > The symptome is that e.g. firefox if it was active and you're switching
> > into X displays its help screen (F1 = help). It happens on non X 
> > consoles too, but of course the symptoms are different here.
> > 
> > That's a regression against 2.6.29; I don't remember it in .29
> > 
> > Haven't investigated code.
> 
> Are you seeing with a specific keyboard type(s), or is this a general 
> problem? Could you confirm whether it is specific either 
> to PS2 or USB keyboards only, or it does happen for both?
> 

Can't think of any input chnages in this timeftrame that would cause
such effect. Maybe TTY changes?

-- 
Dmitry
