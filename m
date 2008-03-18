Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYCSU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYCSU1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbYCSTji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:38 -0400
Received: from gw.goop.org ([64.81.55.164]:39424 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757221AbYCSTir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:47 -0400
Message-ID: <47DFDB39.8070800@goop.org>
Date: Tue, 18 Mar 2008 08:09:45 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr> <47D172A2.5000408@goop.org> <47D4F250.5000307@netone.net.tr> <47D52B79.7030009@netone.net.tr> <47DE3227.2030802@netone.net.tr> <47DE7DCF.6090103@goop.org> <47DF771D.6060707@netone.net.tr>
In-Reply-To: <47DF771D.6060707@netone.net.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> Normally I use the ubuntu's kernel build commands : make-kpkg 
> --revision=1  kernel_image kernel_headers
>
> When I tried with "make bzImage" "make modules", everything went very 
> smooth and it compiled successfully. It seems, some virtualization 
> changes effected the ubuntu's kernel build process. Thank you very 
> much for your help and pointing it, Jeremy. 

I'm guessing that make-kpkg is looking at the .config and when it sees 
CONFIG_XEN=y it does something assuming the old out-of-tree Xen 
patches.  Suse's kernel package builder had a similar problem.

    J
