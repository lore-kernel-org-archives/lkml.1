Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZIVJhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZIVJhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755741AbZIVJhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:37:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:50657 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbZIVJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:37:08 -0400
Date: Tue, 22 Sep 2009 11:37:08 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
Message-ID: <20090922113708.65f655f6@infradead.org>
In-Reply-To: <4AB8980D.5070803@redhat.com>
References: <4AB3CDEC.5050902@zytor.com>
	<1253342422-13811-1-git-send-email-avi@redhat.com>
	<4AB8980D.5070803@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 12:25:33 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 09/19/2009 09:40 AM, Avi Kivity wrote:
> > Add a general per-cpu notifier that is called whenever the kernel is
> > about to return to userspace.  The notifier uses a thread_info flag
> > and existing checks, so there is no impact on user return or context
> > switch fast paths.
> >    
> 
> Ingo/Peter?

isn't this like really expensive when used ?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
