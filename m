Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYIFUNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYIFUNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYIFUNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:13:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:42353 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYIFUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mpnMeiOgAvsjQrw8/Q5m5fwOJhUvuGNNdUzq8L1pI//EtBUkH8u9FuwYCphNbjulBM
         vtfTojS7fWJibPwoK5wG9T7cw15lSMVSlR6B9MQgVmFRQk7BJSugTgjciKHKtnP4ggHX
         evD+7pVO6psEsobPygXfmk9mQuiyCP/hfSBuQ=
Date: Sun, 7 Sep 2008 00:13:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for
	setup_IO_APIC_irqs
Message-ID: <20080906201329.GE23729@lenovo>
References: <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo> <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo> <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl> <20080906190446.GA23729@lenovo> <86802c440809061216n5bbad56amabf9934f8bf08d57@mail.gmail.com> <20080906193820.GC23729@lenovo> <20080906194413.GD23729@lenovo> <Pine.LNX.4.55.0809062104570.13851@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0809062104570.13851@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sat, Sep 06, 2008 at 09:08:51PM +0100]
| On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:
| 
| > So I think better would be just use Ingo's suggestion
| > about to separate apic/pin iterator and function body.
| 
|  No doubt about it.  Then if the number of entries was to be huge, then
| lines output to the log buffer could be limited to 80 characters.  With
| the use of sprintf() it would be rather trivial.  And you would avoid any
| concerns about stack consumption.
| 
|  Please note that with MPS 1.1 systems the number of "unconnected" I/O 
| APIC inputs can be considerable.
| 
|   Maciej
| 

Thanks Maciej, will continue tomorrow.

		- Cyrill -
