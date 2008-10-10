Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbYJJQHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbYJJQHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYJJQHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:07:41 -0400
Received: from outbound-mail-122.bluehost.com ([67.222.38.22]:58924 "HELO
	outbound-mail-122.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753255AbYJJQHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:07:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=N3JMnfbKe2p2iPTBm8oejM6yy8Fwus/I1e8G9OunHrX4mHXze6QoERc5ZFAXGH/8TgqP44pOZSPzltU/u0bAnTvaF45Tbd8kb9vhCLFuVxL5pM3a1H8Thp4+LJSpykOU;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Vincent Legoll" <vincent.legoll@gmail.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Date: Fri, 10 Oct 2008 09:07:35 -0700
User-Agent: KMail/1.9.10
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com> <200810031257.42457.bjorn.helgaas@hp.com> <4727185d0810031550l32592f7ep2d1d37f93be12874@mail.gmail.com>
In-Reply-To: <4727185d0810031550l32592f7ep2d1d37f93be12874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100907.35798.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 3, 2008 3:50 pm Vincent Legoll wrote:
> On Fri, Oct 3, 2008 at 8:57 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > It'll be easier for Jesse if you include the proper changelog again
> > with just a 1-2 line sample of the changed messages.  BTW, the "--"
> > before your sig confused my mailer into not quoting the patch itself,
> > hence the screwed up formatting below.
>
> The "-- " line is the start-of-.sig marker have I been taught in my
> school days, I think they then spoke about netiquette...
>
> > dev_info() is exactly equivalent to dev_printk(KERN_INFO).  I usually
> > use dev_info(), though I'm a bit ambivalent because it's nice to be
> > able to grep for "printk".
>
> I left dev_printk(KERN_INFO, ...) for grepability
>
> > Anyway, maybe you can correct the grammar
> > of "enabled forcedly" to something like "you can enable with ..." when
> > you re-post with the changelog.
>
> I've used "You can enable it back with", hoping the gramar is right
>
> > (Note that dev_dbg() is NOT exactly equivalent to dev_printk(KERN_DEBUG),
> > so you can't change all of them.  dev_printk(KERN_DEBUG) is always
> > compiled in, while dev_dbg() is only compiled in when "DEBUG" is
> > defined.)
>
> Thanks for the hint, for I may have jumped the gun on those "other"
> cleanups ;-)
>
> So here is the new version cut'n'pasted from git-format-patch

Can you respin against linux-next and send me a fresh copy?  This one seems to 
have been corrupted somehow (sorry for the slow reply, it's been sitting in 
my 'to apply' mbox for awhile now).

Thanks,
Jesse
