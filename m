Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZDNRbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZDNRbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757784AbZDNRaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:30:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45446 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758170AbZDNRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:30:11 -0400
Date: Tue, 14 Apr 2009 18:31:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deal with interrupt shadow state for emulated
 instruction
Message-ID: <20090414183111.0243408e@lxorguk.ukuu.org.uk>
In-Reply-To: <49E4B654.6060101@redhat.com>
References: <1239653210-10422-1-git-send-email-glommer@redhat.com>
	<49E45894.7090700@redhat.com>
	<49E4B4D4.1020903@zytor.com>
	<49E4B654.6060101@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why?  Do you see a guest filling all of memory with 'mov ss' and 
> expecting to break out of it via an interrupt?

Well I did try mapping a page of move ss all through memory on real
hardware long ago and seeing what happened on a 386 in real mode with
DOSEMU. I was disappointed ;)

