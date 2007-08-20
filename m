Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbXHTQNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbXHTQNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbXHTQNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 12:13:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58635 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759537AbXHTQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 12:13:07 -0400
Message-ID: <46C9BD8F.4070807@goop.org>
Date: Mon, 20 Aug 2007 09:13:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: John Stoffel <john@stoffel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
References: <46C99371.7070705@bull.net> <18121.39541.790665.686081@stoffel.org> <46C9A7AB.1030003@bull.net>
In-Reply-To: <46C9A7AB.1030003@bull.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> functionnalities:
>
> - allow to measure time spent by a CPU in a virtual CPU.
> - allow to display in /proc/state this value by CPU
> - allow to display in /proc/<pid>/state this value by process
> - allow KVM to use these 3 previous functionnalities
>   

So, currently time spent in a kvm guest is accumulated as qemu-kvm
usertime, right?  Given that qemu knows when its running in qemu vs
guest context, couldn't it provide the breakdown between user and guest
time (ditto lguest)?

    J
