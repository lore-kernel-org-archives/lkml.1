Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbYCMEzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbYCMEzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYCMEzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:55:09 -0400
Received: from main.gmane.org ([80.91.229.2]:46050 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbYCMEzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:55:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Adam Megacz <adam@megacz.com>
Subject: question about PAE and buffercache
Date: Wed, 12 Mar 2008 14:48:30 -0700
Organization: Myself
Message-ID: <x3abl3sjf5.fsf@nowhere.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: feferman.megacz.com
X-Home-Page: http://www.megacz.com/
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Cancel-Lock: sha1:0Q+EDiocH6rOKTQdIuDRWXiUmZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry to ask here, but I looked around for quite a while on the web.

Is the size of the buffercache in any way constrained by the amount of
virtual memory space allocated to the kernel (when using a PAE kernel)?

For example with a 1G/3G split and 8G of physical memory, if userspace
processes aren't interested in more than 6G of that memory, would the
kernel fully utilize all of the remaining 2G for buffercache?

  - a

