Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab0BQOZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 09:25:51 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:53669 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751642Ab0BQOZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 09:25:49 -0500
Date: Wed, 17 Feb 2010 09:25:45 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217142545.GA12165@emergent.ellipticsemi.com>
Mail-Followup-To: Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <201002162206.32797.volkerarmin@googlemail.com>
 <20100216220020.GA1036@emergent.ellipticsemi.com>
 <201002162318.33950.volkerarmin@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002162318.33950.volkerarmin@googlemail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:18 Tue 16 Feb     , Volker Armin Hemmann wrote:
> On Dienstag 16 Februar 2010, Nick Bowler wrote:
> > I put a complete set of recovery tools into my initramfses so that when
> > the system is completely fucked up, I have a kernel that is able to boot
> > until rdinit=/bin/zsh (or /bin/bb, if you prefer) takes over.
> > 
> > This has the added advantage of working when the root filesystem cannot
> > be mounted at all: a scenario which does not seem too far-fetched when
> > the filesystem is located on a raid array.
> 
> and what do you do if you have to boot from a cd/usb stick and need to access 
> the raid?
> 
> Simple with auto assembling. Not so much without.

The same initramfs can be used on a CD or USB stick.  If you were
referring to using someone else's CD or USB stick, then obviously
mdadm will need to be available.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
