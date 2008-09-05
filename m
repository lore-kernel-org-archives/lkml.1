Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYIEAqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYIEAqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYIEAq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:46:27 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:63809 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYIEAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:46:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qHG/CykMfef/DCTcdzOobdk45MxYxZYE1DVKQ7RLaxYM9CNtXucaz9MC40EQZwu+L/
         WtZOY6vmzoXrHuElz4IJ83THQgpEWsAbNMvUrwoGTARkllNsxIxipUeIj9Xy1SewfUfj
         WvBAXN2ZjsSwDXXYgFzTw/N+6z9GKwbR5C3Kc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Barkalow <barkalow@iabervon.org>
Subject: Re: Lenovo 3000 N100 i8042 problems
Date: Thu, 4 Sep 2008 20:46:18 -0400
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <alpine.LNX.1.00.0809031250561.19665@iabervon.org> <alpine.LNX.1.00.0809041957430.19665@iabervon.org>
In-Reply-To: <alpine.LNX.1.00.0809041957430.19665@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809042046.18767.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 September 2008, Daniel Barkalow wrote:
> On Wed, 3 Sep 2008, Daniel Barkalow wrote:
> 
> > On Wed, 3 Sep 2008, Dmitry Torokhov wrote:
> > 
> > > On Tue, Sep 02, 2008 at 12:16:15PM -0400, Daniel Barkalow wrote:
> > > > legacy mode only has a bug that doesn't matter to Windows, and active mux 
> > > > may have some of the usual problems but nothing I particularly noticed.
> > > > 
> > > > I noticed that, when my i8042 would stop working, it would generally have 
> > > > just delivered one mouse interrupt to CPU1 after never previously doing 
> > > > so. Perhaps there's some sort of deadlock in the Linux i8042 driver when 
> > > > both cores are unexpectedly getting interrupts from the two devices at 
> > > > once? I could understand there being a Linux bug only triggered by quirky 
> > > > hardware that only applies to legacy mode, which was just uncovered by 
> > > > this patch.
> > > >
> > > 
> > > I am not sure, internally we the kernel still deals with 2 interrupt
> > > sources (KBD and AUX) regardless whether it is in legacy or active
> > > multiplexing mode...
> > > 
> > > Does it take long to trigger the bug? You coudl try doing "echo 1 >
> > > /sys/modules/i8042/parameters/debug" and thend me dmesg or
> > > /var/log/messages after the bug was triggered - I might see something
> > > there. But please be aware that if you send me such a log I can decode
> > > everything that you have been typing...
> > 
> > It's usually within an hour of the right usage pattern. I'll try to 
> > trigger it with debugging on while not typing anything secret Thursday 
> > evening.
> 
> Attached. 

That is untruth :))

-- 
Dmitry
