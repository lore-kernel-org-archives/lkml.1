Return-Path: <linux-kernel-owner+w=401wt.eu-S1761489AbXGMAtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761489AbXGMAtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXGMAtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:49:11 -0400
Received: from omr11.networksolutionsemail.com ([205.178.146.61]:41960 "EHLO
	omr11.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXGMAtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:49:10 -0400
From: James <LinuxKernel@jamesplace.net>
Reply-To: LinuxKernel@jamesplace.net
To: linux-kernel@vger.kernel.org
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives. --RESOLVED
Date: Thu, 12 Jul 2007 19:49:08 -0500
User-Agent: KMail/1.9.5
Cc: Neil Brown <neilb@suse.de>
References: <200707120849.16068.LinuxKernel@jamesplace.net> <200707121810.57648.LinuxKernel@jamesplace.net> <18070.46997.541325.761868@notabene.brown>
In-Reply-To: <18070.46997.541325.761868@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121949.08662.LinuxKernel@jamesplace.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I don't know the original order of the array before all the problems 
started. 
> > 
> > Is there a way to determine the original order? 
> 
> No, unless you have some old kernel logs of the last time it assembled
> the array properly.
> The one thing that "--create" does destroy is the information about
> any previous array that the drives were a part of.
> 
> > 
> > The order that --detail is showing now is the order that appeared after 
> > issuing the command is it is in the email. (ie: a b c d)
> 
> Odd.  I cannot reproduce it.
> I suggest you try different arrangements (of the 3 good drives and the
> word 'missing') until you find one that 'fsck -n' likes.
> 
> NeilBrown
> 
> 

I don't understand how the order of --detail was different than the command 
line on my system, however....

YOU ARE A LIFE SAVER!!!

After going through 21 combinations, beginning to lose all hope and plummeting 
into eternal despair, combo 22 worked. The array is up and working. All the 
data (1.3Tb) is there and I'm probably the happiest character on the mail 
list today. 

Thanks a bunch for your help.


