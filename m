Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbZCFT1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbZCFT1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZCFT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:26:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:14942 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZCFT0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:26:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=JxlK+ue3GaU8gu5ZJ3mkKw/zVfBCvcZXB2KOlIC1TxgueT0QKCGeAWUsxvQt6Fiq7V
         1V0zVTZGwimlqJt09xKrbTpGrfaXcz1evMAM/GKtj+9T4o/AZhCGlNHLTJSKuyGsqWD5
         75O6OexTay+xBbOEu9R+/pnuy8PJEA/qyuAqc=
Subject: Re: usb/host/pci-quirks: Add option for setting handoff timeout
 for ehci
From: Martin Bammer <mrbm74@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090306175036.GC3099@kroah.com>
References: <1236340355.16732.23.camel@localhost>
	 <20090306175036.GC3099@kroah.com>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 20:26:45 +0100
Message-Id: <1236367605.16732.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes right. It fails faster, because the bios doesn't handoff the device.
But it's no help for the user that he always has to wait 8s because of a
buggy bios. Although the handoff fails the usb-controller works without
any problems.

> > When having a buggy BIOS which doesn't do ehci handoff correctly a 8s
> > boot delay is the result. This patch adds a kernel command line
> > parameter ehci_ho_to to be able to set an arbitrary timeout. On my
> > netbook I've set it to 50 which works without any problems. Maybe the
> > patch would be interesting for others?
> 
> I don't see how this makes anything go faster, you are just changing the
> timeout value, which should only make things fail faster, not succeed
> faster :)
> 
> thanks,
> 
> greg k-h

