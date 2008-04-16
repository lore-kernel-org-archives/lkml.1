Return-Path: <linux-kernel-owner+w=401wt.eu-S932912AbYDPW3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbYDPW3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbYDPW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:54778 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbYDPW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=pr1DDxlqv/QaiNDBgbo+0Pmh8wC5UjKOJiwqXPTKSchRt+Vp0QWc9fb/bfaOUl3QbBdEP6p8iua3c4KlVDL9ffhQl/53iUtMlEoyW1R2I9T4FdGOZUBX9lZ7cRKpgYOHkL60aBTGBsu7U0/7vDhqH3ZA3b85YaM5NLc2l/83Dbg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 3/9] ide: add ->tf_load and ->tf_read methods
Date: Thu, 17 Apr 2008 00:22:30 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080412123401.18751.17246.sendpatchset@localhost.localdomain> <20080412123415.18751.51136.sendpatchset@localhost.localdomain> <480641A2.1080004@ru.mvista.com>
In-Reply-To: <480641A2.1080004@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804170022.30700.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > * Add ->tf_load and ->tf_read methods to ide_hwif_t and set the default
> >   methods in default_hwif_transport().
> 
>     It's not clear to me what do we gain with addign such methods...

in short-term not much besides a nice optimization

in long-term it should enable us to remove ->IN*/OUT* methods completely

> > * Use ->tf_{load,read} instead o calling ide_tf_{load,read}() directly.
> 
> > * Make ide_tf_{load,read}() static.
> 
> > There should be no functional changes caused by this patch.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
