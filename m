Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZIVQ4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZIVQ4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756429AbZIVQ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:56:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbZIVQ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:56:02 -0400
Subject: Re: [PATCH v2] core, x86: Add user return notifiers
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <4AB900B1.9070901@redhat.com>
References: <4AB3CDEC.5050902@zytor.com>
	 <1253342422-13811-1-git-send-email-avi@redhat.com>
	 <4AB8980D.5070803@redhat.com>  <20090922143223.GA31702@elte.hu>
	 <1253638205.18939.4.camel@laptop>  <4AB900B1.9070901@redhat.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:55:54 +0200
Message-Id: <1253638554.18939.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 19:52 +0300, Avi Kivity wrote:
> On 09/22/2009 07:50 PM, Peter Zijlstra wrote:
> >> Would be nice to convert some existing open-coded return-to-user-space
> >> logic to this facility. One such candidate would be lockdep_sys_exit?
> >>      
> > And here I was thinking this was one of the hottest code paths in the
> > whole kernel...
> >    
> 
> If you're using lockdep, surely that's not your biggest worry?

No, but that's all under #ifdef and fully disappears when not enabled.
Generic return-tu-user notifiers don't sound like they will though.

