Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbXI2DJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbXI2DJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 23:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXI2DJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 23:09:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbXI2DJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 23:09:34 -0400
Message-ID: <46FDC1EA.8020203@zytor.com>
Date: Fri, 28 Sep 2007 20:09:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: regression in 2.6.23-rc8 - power off failed on old laptop
References: <20070929010351.GA4768@erig.dyndns.org>
In-Reply-To: <20070929010351.GA4768@erig.dyndns.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfgang Erig wrote:
> Hi,
> 
> the latest kernel does not power off my old laptop.
> 
> 2.6.22 succeeded
> 2.6.23-rc8 failed
> 
> $ git bisect good 
> Bisecting: 0 revisions left to test after this 
> [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
> 
> Which more info is needed?
> 

Okay, I just went back and looked at it... this particular checkin had
*zero* code impact (code not yet turned on), as did any of the checkins
immediately surrounding it.

Since your other email points to
f216cc3748a3a22c2b99390fddcdafa0583791a2, which is a *much* later
checkin, and which seems to actually have something to do with power
states, that the above is a red herring?

	-hpa
