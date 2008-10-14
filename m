Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYJNLBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYJNLBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYJNLBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:01:45 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:33743 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYJNLBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:01:45 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Nicolas Bareil <nico@chdir.org>
Subject: Re: USB problem on x86_64: nommu_map_single() issue?
Date: Tue, 14 Oct 2008 13:00:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20081014072045.GA1252@sd-5945.dedibox.fr> <200810141148.48220.oliver@neukum.org> <20081014104500.GB1252@sd-5945.dedibox.fr>
In-Reply-To: <20081014104500.GB1252@sd-5945.dedibox.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810141300.29502.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Oktober 2008 12:45:00 schrieb Nicolas Bareil:

Hello,

> Hi Oliver,
> 
> On Tue, Oct 14, 2008 at 11:48:47AM +0200, Oliver Neukum wrote:
> > > On 2.6.27, I can't use any USB device (mass storage, mouse) anymore on my x86_64 system, the devices
> > > are not detected: lsusb returns nothing except the hub.
> > 
> > Is this a regression? Did it work on earlier kernels?
> 
> Yes this is a regression: USB works in 2.6.26.x with (almost) the same configuration.

This a an IOMMU problem, not really a USB problem. Can you bisect the problem?

	Regards
		Oliver
