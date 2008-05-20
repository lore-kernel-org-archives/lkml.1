Return-Path: <linux-kernel-owner+w=401wt.eu-S935444AbYETWoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935444AbYETWoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935227AbYETWkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:40:17 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:3314 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935191AbYETWkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:40:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XemRUON7JvbUGd9lAs88H68d8J8Oqf/xt19DXj4ZMvkgfpvGD+vd+CMmrIC9DbswTGvtcsb1I5oWrKLrdvpnuxCDyNTYJfU5mNILEwBccagHvfpfpEWS2+lasTZXXiFW9R5Ah1ZoidQfcpsJakjanBzdagiaRTYhPUTukAqDBrU=
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from
	lib/hexdump.c instead
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: crquan@gmail.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080520.153611.204837174.davem@davemloft.net>
References: <1211135864-8235-1-git-send-email-crquan@gmail.com>
	 <20080520.153611.204837174.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:40:12 -0700
Message-Id: <1211323212.5915.220.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-20 at 15:36 -0700, David Miller wrote:
> From: Denis Cheng <crquan@gmail.com>
> Date: Mon, 19 May 2008 02:37:44 +0800
> 
> > Here the local hexbuf is a duplicate of global const char hex_asc from
> > lib/hexdump.c, except the hex letters' cases:
> > 
> > const char hexbuf[] = "0123456789ABCDEF";
> > 
> > const char hex_asc[] = "0123456789abcdef";
> > 
> > and here to print HW addresses, the hex cases are not significant.
> > 
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
> 
> Applied, thanks.

You may want to use the hex_asc_hi, hex_asc_lo helpers to do the
mask/shifts for you.

Harvey

