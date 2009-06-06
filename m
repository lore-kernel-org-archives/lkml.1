Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZFFHcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZFFHcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 03:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZFFHbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 03:31:46 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:52377 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372AbZFFHbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 03:31:46 -0400
From: Frans Pop <elendil@planet.nl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/2] pnp: add PNP resource range checking function
Date: Sat, 6 Jun 2009 09:31:34 +0200
User-Agent: KMail/1.9.9
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, apw@canonical.com,
       colin.king@canonical.com, tim.gardner@canonicalc.com,
       bjorn.helgaas@hp.com
References: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
In-reply-To: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906060931.36168.elendil@planet.nl>
X-OriginalArrivalTime: 06 Jun 2009 07:31:46.0994 (UTC) FILETIME=[D91F4920:01C9E678]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add a PNP resource range check function, indicating whether a resource
> has been assigned to any device.

Shouldn't this patch come *before* your patch 1/2?
You now seem to use this function in a commit where it has not yet been 
defined, which could result in build errors during bisections.

Cheers,
FJP
