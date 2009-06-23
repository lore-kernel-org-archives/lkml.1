Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZFWCja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZFWCja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZFWCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:39:17 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:51400
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbZFWCjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:39:16 -0400
Message-ID: <4A404049.1080707@mit.edu>
Date: Mon, 22 Jun 2009 22:39:05 -0400
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jerome Glisse <jglisse@redhat.com>
CC: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] radeon: fix radeon kms framebuffer device
References: <1245687358-10481-1-git-send-email-jglisse@redhat.com>
In-Reply-To: <1245687358-10481-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Glisse wrote:
> smem.start is a physical address which kernel can remap to access
> video memory of the fb buffer. We now pin the fb buffer into vram
> by doing so we are loosing vram but fbdev need to be reworked to
> allow change in framebuffer address.

I tested this (and the corresponding 2/2 initialization order, but with 
radeon as a module), and plymouth seems to be fully functional 
(graphical boot, password prompt, etc).

(The driver set the wrong mode, but that's a different issue.)

Thanks!

Tested-by: Andy Lutomirski <luto@mit.edu>
