Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbZDGLM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbZDGLM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDGLMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:12:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41859 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751663AbZDGLMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:12:18 -0400
Date: Tue, 7 Apr 2009 12:13:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Elina <epasheva@sierrawireless.com>
Cc: <gregkh@suse.de>, <rfiler@sierrawireless.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 001/003] USB: serial: sierra driver performance
 improvements
Message-ID: <20090407121323.1a9525ca@lxorguk.ukuu.org.uk>
In-Reply-To: <1239062754.10120.36.camel@Linuxdev3>
References: <1239062754.10120.36.camel@Linuxdev3>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	printk(KERN_ERR "################################%s\n", __func__);

Sorry  - you seem to have left a load of debug in this ?

These should be KERN_DEBUG and I suspect inside the debug macros ?
