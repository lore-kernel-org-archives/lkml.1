Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYCaGh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYCaGh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 02:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYCaGhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 02:37:50 -0400
Received: from gw.goop.org ([64.81.55.164]:45992 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYCaGht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 02:37:49 -0400
Message-ID: <47F08688.6050206@goop.org>
Date: Sun, 30 Mar 2008 23:36:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       mingo@redhat.com
Subject: Re: xen: Make hvc0 the preferred console in domU
References: <87zltm1p0s.fsf@pike.pond.sub.org>
In-Reply-To: <87zltm1p0s.fsf@pike.pond.sub.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Armbruster wrote:
> This makes the Xen console just work.  Before, you had to ask for it
> on the kernel command line with console=hvc0
>   

I see that this has been causing issues when people expect the pvfb 
driver to be the console.  Should we make it a config option, which 
depends on !XENFB?

    J
