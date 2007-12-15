Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbXLOTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbXLOTUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 14:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbXLOTUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 14:20:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:50980 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbXLOTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 14:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=O9blpbgE6DTJUDrVrtE7oHLAS7uiIaGGLA9eYEBqFgI8f9+vNsvyRXDo5T8aqfTweAVmYWSqerIZGczuamI2lfUSYmAFxNEZLxzuxvIsXW5anJVoyk1j1SZjkQ5h/wDTxEagwZohW58Qqs3lSWP8ftlL+fXRC2U5ETepzctseAI=
Date: Sat, 15 Dec 2007 22:20:24 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1
Message-ID: <20071215192024.GA2419@martell.zuzino.mipt.ru>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I got the following at reboot after some tests were finished:

get_unused_fd: slot 3 not NULL!
get_unised_fd: slot 4 not NULL!
general protection fault: 0000 [1] PREEMPT SMP
last sysfs file /sys/class/scsh_host/host1/link_power_management_policy

and that's all.
