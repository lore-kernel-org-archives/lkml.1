Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZA2Vgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZA2Vgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZA2Vgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:36:35 -0500
Received: from gw.goop.org ([64.81.55.164]:59809 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZA2Vgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:36:35 -0500
Message-ID: <49822161.6050205@goop.org>
Date: Thu, 29 Jan 2009 13:36:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: pass in cpu number to switch_to_new_gdt()
References: <49818842.5020004@goop.org> <1233236625-17928-1-git-send-email-brgerst@gmail.com>
In-Reply-To: <1233236625-17928-1-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Impact: cleanup, prepare for xen boot fix.
>
> Xen needs to call this function very early to setup the GDT and
> per-cpu segments.  Remove the call to smp_processor_id() and just
> pass in the cpu number.
>   

Unfortunate that still not sufficient for a Xen boot.  I had to separate 
the gdt reload from the segment register reload.  Patches follow.

    J
