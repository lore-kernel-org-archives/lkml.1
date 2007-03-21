Return-Path: <linux-kernel-owner+w=401wt.eu-S964801AbXCUUKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbXCUUKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964798AbXCUUKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:10:12 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:50388 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbXCUUKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:10:11 -0400
Date: Wed, 21 Mar 2007 16:10:07 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: tglx@linutronix.de, mingo@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: fix formatting in /proc/timer_list
In-Reply-To: <Line.LNX.4.64.0703211548050.13394@d.namei>
Message-ID: <Line.LNX.4.64.0703211609090.13523@d.namei>
References: <Line.LNX.4.64.0703211548050.13394@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, James Morris wrote:

> Fix the print formatting of three unsigned long fields in 
> /proc/timer_list, which are currently being formatted as unsigned int.
                                                            ^^^^^^^^^^

The last bit should be 'signed long'.


-- 
James Morris
<jmorris@namei.org>
