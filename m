Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246Ab0A0Tc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab0A0Tc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 14:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799Ab0A0Tc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 14:32:28 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:60635 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab0A0Tc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 14:32:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E4nEHKpT+NwvyB2QWqbr6jRCI78J5ROuLdPhjQtiznexo3ShFmKv49FLAPnyVUT2GW
         eDvL/+eCkFarhEakk2IPaSsZvS7FmwnOUcKK1I+5cIOVfLanU+N6T8DQhksk5z3rH0Fn
         DL+wsGA9kZvAME0CBUThAT+UKBgYGkfJ3cm74=
Date: Wed, 27 Jan 2010 20:32:20 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Subject: Re: Hang: 2.6.32.4 sky2/DMAR (was [PATCH] sky2: Fix WARNING: at
 lib/dma-debug.c:902 check_sync)
Message-ID: <20100127193220.GB3135@del.dom.local>
References: <20100122234656.GC3105@del.dom.local>
 <4B5A39BD.8020305@majjas.com>
 <20100123232133.GA3487@del.dom.local>
 <4B605D1B.60402@majjas.com>
 <20100127085049.5b5048e9@nehalam>
 <4B60707F.1000608@majjas.com>
 <20100127095614.14313677@nehalam>
 <4B608128.7090607@majjas.com>
 <4B6089C7.4010803@majjas.com>
 <20100127192312.GA3135@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127192312.GA3135@del.dom.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 08:23:12PM +0100, Jarek Poplawski wrote:
> Stephen, I'm not sure this patch can show much after the patch with
> "legal" dma_size == re->data_addr didn't help. It looks like David

Of course: "dma_size == re->data_size".

Jarek P.
