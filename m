Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbZCOXCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbZCOXCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZCOXCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:02:25 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:53969 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZCOXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:02:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8FAJokvUlR88Bs/2dsb2JhbACBTs4Yg38G
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: "Robin H. Johnson" <robbat2@orbis-terrarum.net>
Subject: Re: [PATCH UVC] Add UVC entry for Logitech Quickcam Orbit AF.
Date: Mon, 16 Mar 2009 00:02:52 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.28; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1237080405-13437-1-git-send-email-robbat2@orbis-terrarum.net> <200903151153.36688.laurent.pinchart@skynet.be> <20090315152845.GB9084@curie-int>
In-Reply-To: <20090315152845.GB9084@curie-int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903160002.53181.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robin,

On Sunday 15 March 2009 16:28:45 Robin H. Johnson wrote:
> On Sun, Mar 15, 2009 at 11:53:36AM +0100, Laurent Pinchart wrote:
> > Hi Robin,
> >
> > On Sunday 15 March 2009 02:26:45 Robin H. Johnson wrote:
> > > Need explicit entry like many of the other Logitech devices as it does
> > > not match the class otherwise.
> >
> > Are you sure about that ? The Logitech Quickcam Orbit AF I got here
> > matches the standard UVC class. Could you please post the output of
> > lsusb -v -d 046d:0994
> > on your system with the camera plugged in ?
>
> See attached camera-046d-0994

Thanks. Your camera descriptors are definitely UVC compliant, the patch is 
thus unneeded.

> I meant to send in the patch sooner, but I've been carrying it in my
> local tree since 2.6.28 in December.
>
> If the automatic detection and PTZ control work fine now, then I
> apologize for the spurious patch, but booting back to my older kernels
> finds it not working in stock 2.6.28.

Pan and tilt controls on Logitech devices require an external tool called 
uvcdynctrl to configure the driver.

Best regards,

Laurent Pinchart

