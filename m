Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0CCPwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:52:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39247 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753353Ab0CCPwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:52:32 -0500
Date: Wed, 3 Mar 2010 15:55:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v2] hvc_console: Fix race between hvc_close and
 hvc_remove
Message-ID: <20100303155522.6d6a4562@lxorguk.ukuu.org.uk>
In-Reply-To: <1267630188-30824-1-git-send-email-amit.shah@redhat.com>
References: <1267630188-30824-1-git-send-email-amit.shah@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Mar 2010 20:59:48 +0530
Amit Shah <amit.shah@redhat.com> wrote:

> Alan pointed out a race in the code where hvc_remove is invoked. The
> recent virtio_console work is the first user of hvc_remove().

Looks better to me.

Alan
