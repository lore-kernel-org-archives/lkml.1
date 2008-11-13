Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYKMSLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYKMSLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 13:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYKMSK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 13:10:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:7828 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbYKMSKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 13:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=khBZTbU7CV2pa4sJwOyLauUjQFCrWbPTYw2Pq3ZnYPxJ+TmoaSyEB88Khl0vL5nHOa
         QCE+7raT+bux2U3VuiW1jiqsmCgorNbxa441O9onoaqNF2PgF94FCnCrC3qpQtx3vQts
         i24ilSpp4KOFCF3ceQg8M2BR2jExk714v/pRM=
Message-ID: <491C6DA6.8030200@gmail.com>
Date: Thu, 13 Nov 2008 18:10:46 +0000
From: Saikiran Madugula <hummerbliss@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] remove an unnecessary field in struct tcp_skb_cb
References: <1226571707.18006.23.camel@nathan.suse.cz>
In-Reply-To: <1226571707.18006.23.camel@nathan.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> The urg_ptr field is not used anywhere and is merely confusing.
> 
grep -r "urg_ptr" on my linux tree says otherwise.
