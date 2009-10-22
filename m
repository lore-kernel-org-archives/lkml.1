Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZJVF4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZJVF4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 01:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZJVF4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 01:56:49 -0400
Received: from ozlabs.org ([203.10.76.45]:39759 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZJVF4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 01:56:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Paris <eparis@redhat.com>
Subject: Re: request_module vs. modprobe blacklist (and security subsystem implications)
Date: Thu, 22 Oct 2009 16:26:49 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       randy.dunlap@oracle.com, andi@firstfloor.org, dhowells@redhat.com,
       akpm@linux-foundation.org
References: <1256137348.4443.39.camel@dhcp231-106.rdu.redhat.com> <9b2b86520910211211o30fab495r3a43cc4de9d4e968@mail.gmail.com> <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256153248.4443.49.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910221626.51170.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 05:57:28 am Eric Paris wrote:
> Ah yes, not your fault though  :)  The problem is that SELinux reports
> these denials and users get scared.  We can (and now do) silence all of
> these SELinux caused denials, but now we have no notification if a
> malicious program tried to cause the auto loading of a module.

Well, yes.  I think you need to be more careful in your filtering.

If a userspace program tries some security exploit that has been closed, do
you want to warn about it?  Because that seems to be the question here.

Why should ssh not load IPv6?  Because noone should?  Fine, but there's a
difference between "I expect it to do this but I won't let it" and "I don't
expect it to do this".

I think the question is bigger than modprobe.conf vs request_module.

Or am I confused?
Rusty.
