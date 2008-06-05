Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbYFEBGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbYFEBGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYFEBGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:06:40 -0400
Received: from sous-sol.org ([216.99.217.87]:37073 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYFEBGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:06:39 -0400
Date: Wed, 4 Jun 2008 18:06:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Thorsten Knabe <linux@thorsten-knabe.de>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
Message-ID: <20080605010626.GB30402@sequoia.sous-sol.org>
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org> <20080602010546.GA8578@c2.user-mode-linux.org> <484719C7.2020502@thorsten-knabe.de> <20080605004925.GA15461@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605004925.GA15461@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeff Dike (jdike@addtoit.com) wrote:
> Yes, it does.  I don't see the flags causing a leak, though.  What
> might be more likely (although I really have no idea) is ptrace.

Yeah, ptrace was my guess as well, and I was hoping you'd have an idea ;-)

> Possibly a reference is held when it should have been dropped.  This
> might also show up with strace or gdb.
