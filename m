Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYJXUaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYJXUaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYJXUaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:30:00 -0400
Received: from 1wt.eu ([62.212.114.60]:4917 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbYJXU37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:29:59 -0400
Date: Fri, 24 Oct 2008 22:29:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: j.d.-linux-kernel@arcor.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: How can I build a 2.4 kernel on a 2.6 System
Message-ID: <20081024202955.GT24654@1wt.eu>
References: <16891148.1224850600689.JavaMail.ngmail@webmail18.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16891148.1224850600689.JavaMail.ngmail@webmail18.arcor-online.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 24, 2008 at 02:16:40PM +0200, j.d.-linux-kernel@arcor.de wrote:
> Hello list
> 
> I will build some 2.4 kernel modules on a system with a running 2.6 kernel.
> 
> Is it possible and how can I do this?

Not sure what you really mean. If you mean build 2.4 modules for 2.4 on
a machine running 2.6, that's OK as there's no dependency between the
running kernel and the one you're building. However, you should be
careful about two things :
  - gcc: it tends to be too recent for 2.4. gcc 4.1 is the highest version
    supported.
  - modutils: most recent distros only ship module-init-tools without the
    old depmod. If you intend to "make modules_install INSTALL_MOD_PATH=..."
    then get prepared to see some errors from depmod at the end. The easiest
    solution consists in getting a depmod from an old machine an installing
    it in /tmp for instance.

Hoping this helps,
Willy

