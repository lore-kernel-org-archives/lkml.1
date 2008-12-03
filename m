Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbYLCUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbYLCUkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYLCUdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 15:33:23 -0500
Received: from kroah.org ([198.145.64.141]:40143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762054AbYLCUdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 15:33:22 -0500
Date: Wed, 3 Dec 2008 12:32:15 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, sfr@canb.auug.org.au,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [ath9k-devel] [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX
	gracefully
Message-ID: <20081203203215.GA30927@kroah.com>
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com> <1228251082-11677-2-git-send-email-lrodriguez@atheros.com> <1228251082-11677-3-git-send-email-lrodriguez@atheros.com> <1228251082-11677-4-git-send-email-lrodriguez@atheros.com> <20081203001253.GC14943@kroah.com> <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com> <20081203002404.GA22789@tuxdriver.com> <43e72e890812031219t6a8c0d57hf54f376730a0655c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43e72e890812031219t6a8c0d57hf54f376730a0655c@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 12:19:22PM -0800, Luis R. Rodriguez wrote:
> On Tue, Dec 2, 2008 at 4:24 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > On Tue, Dec 02, 2008 at 04:20:32PM -0800, Luis R. Rodriguez wrote:
> >> On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
> >> > I don't see this patch upstream in Linus's tree.  Am I just missing it
> >> > and if so, do you know the git commit id?
> >>
> >> Nope sorry, John has yet to send his pending-fixes branch to davem and
> >> so forth, which would contain it AFAICT. Please correct me if I'm
> >> wrong John.
> >
> > It has been sent, and Dave sent his pull request to Linus today
> > (or maybe yesterday).  I'll try to dig-up the commit IDs tomorrow.
> 
> Greg, I see two of these patches in 2.6.27-stable review patch but the
> one in this subject was not applied, any specific reason or was it
> just missed?

It was not applied because it was not yet in Linus's tree, which is a
requirement for it to go into the 2.6.27-stable tree.

thanks,

greg k-h
