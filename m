Return-Path: <linux-kernel-owner+w=401wt.eu-S2992687AbXCGWiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992687AbXCGWiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992657AbXCGWiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:38:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35207 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992687AbXCGWiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:38:11 -0500
Date: Wed, 7 Mar 2007 14:38:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pat Gefre <pfg@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6 Altix : console fix for CONFIG_DEBUG_SHIRQ usage
Message-Id: <20070307143809.f103944f.akpm@linux-foundation.org>
In-Reply-To: <200703072157.l27Lv87s240185@fsgi900.americas.sgi.com>
References: <200703072157.l27Lv87s240185@fsgi900.americas.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 15:57:07 -0600 (CST)
Pat Gefre <pfg@sgi.com> wrote:

> The sn console driver was snagged by the use of CONFIG_DEBUG_SHIRQ !
> 
> The request_irq() immediate call to the interrupt handler caused
> another attempt to lock the port lock - deadlock.
> 
> This is a patch to fix that.

Should this go into 2.6.20.x as well?
