Return-Path: <linux-kernel-owner+w=401wt.eu-S1422893AbYHFVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422893AbYHFVZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYHFVRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:17:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:54829 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbYHFVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Nba1t2/8/qGkRobIOtVNLTIs4gf/xKzrD4cfI3KwDkcFwsOAxB4MyEgNEjQ3pgGe7v
         QuodhkJPgSkXRq/fSbaHKJzZpCi9478w6WxZ2cyLZRDtvOztLvO5Z8jrG4m8UjW/rTkZ
         HK8gUFRiCKGJgRgRlhMb4LoAOEEWrN5mphia4=
Message-ID: <489A1364.4020809@gmail.com>
Date: Wed, 06 Aug 2008 23:11:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ira Snyder <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Simple UART driver help and TTY questions
References: <20080805163307.GJ6257@ovro.caltech.edu>
In-Reply-To: <20080805163307.GJ6257@ovro.caltech.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

conOn 08/05/2008 06:33 PM, Ira Snyder wrote:
> static void tiny_config_port(struct uart_port *port, int flags)
> {
> 	FUNC_ENTER();

         if (flags & UART_CONFIG_TYPE)
                 port->type = PORT_16550A;

> }

According to the straces, you get -EIO from ioctl and read which most likely 
means TTY_IO_ERROR bit set due to tiny_port->type = PORT_UNKNOWN (i.e. 0). Try 
the above.
