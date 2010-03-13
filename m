Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab0CMGLv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:11:51 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:21521 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0CMGLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:11:50 -0500
Subject: Re: Regression in i915 on 2.6.34-rc1
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: dri-devel@lists.sourceforge.net, airlied@linux.ie,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
In-Reply-To: <1268458676.28444.9.camel@dc7800.home>
References: <20100311003358.58194366@redhat.com>
	 <20100312182519.3723e970@redhat.com> <1268458676.28444.9.camel@dc7800.home>
Content-Type: text/plain
Date: Fri, 12 Mar 2010 23:04:26 -0700
Message-Id: <1268460266.28444.10.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 22:37 -0700, Bjorn Helgaas wrote:
> On Fri, 2010-03-12 at 18:25 -0700, Pete Zaitcev wrote:
> > On Thu, 11 Mar 2010 00:33:58 -0700, Pete Zaitcev <zaitcev@redhat.com> wrote:
> > 
> > I apologise for answering to myself, but while there was no answer,
> > git bisect found the offending commit and I verified that it was
> > the culprit. Also, I am adding Bjorn and Jesse to cc:.
> > 
> > > I seem to hit a sudden regression in 2.6.34-rc1: the modeset fails.
> > > On this box it also means, no way to start X, which is unfortunate.

Oh, and I forgot to mention: booting with "pci=nocrs" should be a
workaround while we figure out the problem.

Bjorn


