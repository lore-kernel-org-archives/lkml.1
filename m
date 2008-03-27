Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbYC0Ts5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbYC0Ts5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 15:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbYC0Tsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 15:48:47 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:42300 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758130AbYC0Tsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 15:48:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RcvmMD0upqZTQDqo/t3KVx2Y1pDr6PSRzV/8xfge6voCot0btheJDaKyshtKWddFB2M58nyQlLpxt/rUknFTpgFFLJMRbCLLDkwRFm8FGEi2b1EnZk9iXApWNUs4L1Eg+/xZaufEvqndskZfwa04RROMMajD4Dcq6E/hhK3H/Gs=  ;
X-YMail-OSG: fG5vjOYVM1mc73N8QQrkI8AynKOIlRwxnjhaWPVq7STcfpR0EBejcc3kjxglmR4xNndCpK_5oWIpNyEzR5RMYtof
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: mgross@linux.intel.com
Subject: Re: Real time USB2Serial devices and behaivor
Date: Thu, 27 Mar 2008 12:48:40 -0700
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, linux-usb@vger.kernel.org
References: <20080326152559.GA17164@linux.intel.com> <20080326162728.GC6020@kroah.com> <20080326164946.GA17928@linux.intel.com>
In-Reply-To: <20080326164946.GA17928@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803271248.40519.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 March 2008, mark gross wrote:
> On Wed, Mar 26, 2008 at 09:27:28AM -0700, Greg KH wrote:
> > Give up and use a "real" serial port, you'll have better luck :)
> 
> but its getting very hard to find real serial ports any more :(

I happened across this the other day, and saved the URL since
the price was relatively sane ... $15 vs the $60 I saw at
another site, although ISTR Fry's used to have them at $5:

  http://www.wrighthobbies.net/catalog/index.php?cPath=47

Yeah, I know.  "It's getting very hard to find real PCI slots
any more."  :(

It seems like some companies (notably *cough* Intel) are
on a little jihad to get rid of serial ports...


I'd think that in a controlled environment (fixed set of
USB connections) USB should be able to meet fairly chosen
"real time" latency ceilings.  The stack probably needs a
few semantic updates to make it happen -- e.g. URB completions
are issued in_irq() -- but it shouldn't be insurmountable.

- Dave

