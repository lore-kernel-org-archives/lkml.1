Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXCUQNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXCUQNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932875AbXCUQNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:13:44 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:26817 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932857AbXCUQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:13:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WQ/mguynIycFgsJQKwkdrrihpSbx1En6hzoqdbUuX5g0p7givP0eMLQRRnaysYurRxiBhjQYMGcS5hGJPbsd0nVlmvaZNThfk3cLN53wE122Wm8nx5MN6DIH+2sZ0S10GoqrVjJKDGdx4gacXPV7C5EXCATsUTTXOZiNPECh340=  ;
X-YMail-OSG: datPkmcVM1m9.G1bXulv37U1.nsXQg1fLx1fa3KRg.hTY8bt.OWSGRZwZzPuLTVvYgQ8XcjIEQtPqz27agOoKwUYD4LAlFsZlWpGXAWQnRKMHbU7Lv8LHw--
From: David Brownell <david-b@pacbell.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [patch 2.6.21-rc4-git] SCSI newstyle hotplug/coldplug support
Date: Wed, 21 Mar 2007 10:13:34 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
References: <200703201736.09280.david-b@pacbell.net> <46011075.6050608@tls.msk.ru>
In-Reply-To: <46011075.6050608@tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703211013.35183.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 4:01 am, Michael Tokarev wrote:
> David Brownell wrote:
> > This teaches scsi devices how to support "new style" hotplug/coldplug:
> > using a modalias sysfs attribute for coldplug, and MODALIAS environment
> > variable for hotplug.
> 
> How this is different from http://marc.info/?t=115204542200002&r=1&w=2 and
> earlier attempts to do the same?

Not very; I didn't know about previous work.
Why hasn't such support been merged yet?

- Dave
