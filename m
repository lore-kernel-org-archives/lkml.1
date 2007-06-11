Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXFKXaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXFKXaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 19:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXFKXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 19:30:14 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:45295 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754190AbXFKXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 19:30:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5jM2JcwT7aF/ANQIGvm/DVwSO8eKm5wvpqV6VQEof8s+UFOmkTdO5TRzE1S6pz4EfgPW6zs6+rI6RiSsFajgEo8dOWrwo/Ztb5n3L/acQa6n46XiBi/8dfpuB7Al9AyVl7bnJudgMIXqvBub7GYN6ePe+q39Ktoee4fA9Rm7RSY=;
X-YMail-OSG: lVjaYkYVM1l5mTFEHw4CtADZADAniGhnpiNdexgAh.Qz1USix.A8lIoWAnhQZY.jjbdH.Q--
Date: Mon, 11 Jun 2007 16:30:11 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Reply-To: dougthompson@xmission.com
Subject: Re: [PATCH 4/6] include linux pci_id-h add amd northbridge defines
To: Greg KH <greg@kroah.com>, dougthompson@xmission.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070609000827.GA17624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <963615.80973.qm@web50105.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Greg KH <greg@kroah.com> wrote:

> On Fri, Jun 08, 2007 at 10:45:10AM -0600, dougthompson@xmission.com wrote:
> > From:	Douglas Thompson <dougthompson@xmission.com>
> > 
> > pci_ids.h needs two of the AMD NB device-ids namely,
> > Addressmap and the Memory Controller devices
> 
> Does any kernel driver need this?  We're trying to only include things
> in the pci_ids.h file that are needed in more than one file to cut down
> on the churn here for unnecessary ids.

not at the moment, but I have the k8_edac.c EDAC driver in my queue, which was in the -mm tree but
I had to pull it back once.

I am working with the k8 driver and its dealing with a race with the mcelog device as both access
the K8 NB. The K8 driver does use these regs and it currently has #ifndef s in it for both of
them.

I guess I could have submitted the patch when the K8 driver was submitted.

thanks

doug t

> 
> thanks,
> 
> greg k-h
> 

