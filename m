Return-Path: <linux-kernel-owner+w=401wt.eu-S965851AbXDBU5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851AbXDBU5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965866AbXDBU5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:57:10 -0400
Received: from gw.goop.org ([64.81.55.164]:47288 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965865AbXDBU5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:57:09 -0400
Message-ID: <46116E12.5070206@goop.org>
Date: Mon, 02 Apr 2007 13:56:50 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: A set of "standard" virtual devices?
References: <4611652F.700@zytor.com>
In-Reply-To: <4611652F.700@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On the subject of virtualization; there are a number of devices which
> keep being invented and reinvented by just about every virtualization
> vendor for no really good reason.
>
> I personally recently pointed out that a proper virtualization
> solution should handle entropy collection at the lowest level (where
> the physical hardware drivers are) and present a hw_rng interface to
> the guests. Unfortunately, none of the hardware-based hw_rng
> interfaces is sane enough to do that with, which calls for a virtual
> driver.
>
> It would be nice if there was one, and not a dozen, such drivers.
>
> I would therefore like to propose that the Linux Foundation register a
> PCI ID for use by LANANA ($3000/year), and we set up a LANANA registry
> for these device IDs, together with a description of the device
> interface each of them expect.  Similarly, a Subsystem ID registry can
> be used (for virtualization vendors which don't have their own VID
> already) to distinguish different implementations.
>
> Obviously, anyone who adheres to the published interface can use one
> of these VID:DIDs -- as far as I'm concerned, even hardware vendors;
> we'll use the SID to distinguish between implementations. 

How would that work in the case where virtualized guests don't have a
visible PCI bus, and the virtual environment doesn't pretend to emulate
a PCI bus?

    J
