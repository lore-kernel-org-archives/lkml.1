Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbZAUXKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbZAUXKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 18:10:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZAUXJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 18:09:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbZAUXJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 18:09:50 -0500
Message-ID: <4977AB27.8080608@zytor.com>
Date: Wed, 21 Jan 2009 15:09:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: kmh@nerdshack.com
CC: linux-kernel@vger.kernel.org, lermen@elserv.ffm.fgan.de, lermen@fgan.de,
       davej@redhat.com, cebbert@redhat.com
Subject: Re: PROBLEM: loadlin incompatible with 2.6.23 kernels
References: <200712022336.SAA12095@granite.sover.net>
In-Reply-To: <200712022336.SAA12095@granite.sover.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kenneth Howlett wrote:
> I do not know if the problem is with the kernel or with loadlin. Probably
> some people will say it is the kernel's fault, and other people will say it
> is loadlin's fault.
> 
> I do not know why this occurs with loadlin and not with other boot loaders.

LOADLIN uses memory it isn't allowed to use by the boot protocol.  Newer 
kernels use more memory than previous ones, and starts using memory 
LOADLIN expects to use.

Unfortunately LOADLIN hasn't been updated for a very long time, and 
there doesn't seem to be much interest in maintaining it.

	-hpa
